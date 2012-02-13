module App
  class Status < ActiveRecord::Base
    
    def self.per_page
      30
    end

    default_scope :order => "tweeted_at DESC"

    belongs_to :account, :class_name => 'App::Account'
    belongs_to :author, :class_name => 'App::Account'
    belongs_to :reply_to, :class_name => 'App::Status'

    belongs_to :search, :class_name => 'App::Search'
    
    has_many :replies, :class_name => 'App::Status', :foreign_key => 'reply_to_id'

    has_many :retweets, :class_name => 'App::Retweet', :foreign_key => 'retweet_id'
    has_many :retweet_authors, :through => :retweets, :source => :author

    validates_uniqueness_of :twitter_id, :scope => :account_id
    validates_presence_of :account_id
    validates_presence_of :author_id

    serialize :coordinates

    after_create :publish_event!
    after_update :ensure_published_event!
    before_save :expire_cache

    named_scope :recent, :limit => 20, :order => "tweeted_at DESC"
    named_scope :today, :conditions => ['tweeted_at > ? AND tweeted_at < ?', Date.today.beginning_of_day, Date.today.end_of_day], :order => "tweeted_at DESC"
    named_scope :this_week, :conditions => ['tweeted_at > ? AND tweeted_at < ?', Date.today.beginning_of_week, Date.today.end_of_week], :order => "tweeted_at DESC"
    named_scope :containing_links, :conditions => ['message LIKE ? OR message LIKE ?', "%http://%", "%www.%"]
    named_scope :containing_mention, :conditions => ['message LIKE ?', "% @%"]
    named_scope :containing_question, :conditions => ['message LIKE ?', "%? %"]
    
    def mention?
      self.mentioned?
    end

    def from_mash(mash)
      
      self.message = mash.text
      self.source = mash.source
      self.tweeted_at = mash.created_at
      self.coordinates = mash.geo.coordinates if mash.geo && mash.geo.coordinates

      author = App::Account.find_or_initialize_by_screen_name(mash.user.screen_name)
      author.from_mash!(mash.user)
      author.save!

      self.author = author

      if mash.in_reply_to_status_id
        begin
          reply_to = App::Status.find_or_initialize_by_twitter_id_and_account_id(mash.in_reply_to_status_id, self.account.id)

          if reply_to.new_record?
            reply_to.account = self.account
            reply_to = reply_to.from_mash(self.account.client.status(mash.in_reply_to_status_id))
          end

          reply_to.save!

          self.reply_to = reply_to
          self.reply_to_author = reply_to.author
        rescue Twitter::General
          # Not authorised to view tweet
        end
      end

      unless mash.retweeted_status.nil?
        retweet = App::Status.find_or_initialize_by_twitter_id_and_account_id(mash.retweeted_status.id, self.account.id)

        if retweet.new_record?
          retweet.account = self.account
          retweet = retweet.from_mash(mash.retweeted_status)
        end

        retweet.save!

        self.retweet_id = retweet.id
        self.retweet_author_id = retweet.author_id
        self.type = 'App::Retweet'
        self.becomes(App::Retweet)
      else
        self
      end
    end
    
    def from_search_mash(mash, search, current_account)
      self.message     = mash.text
      self.source      = CGI.unescapeHTML(mash.source)
      self.tweeted_at  = mash.created_at
      self.search      = search
      
      author = App::Account.find_or_initialize_by_screen_name(mash.from_user)
      
      if author.new_record?
        user = current_account.client.user(author.screen_name)
        author.from_mash!(user)
        author.save!
      end
      
      self.author = author
      self
    end
    
    private
    
    def expire_cache
      #FIXME, probably not the best way of handling this, need to refactor out into observer
      ActionController::Base.new.expire_fragment "status#{self.id}"
      nil
    end
    
    def publish_event!
      case self.type.to_s
      when "App::DirectMessage"
        Event.publish!(self.becomes(self.type.constantize), :force_create => true)
      else
        if self.mention?
          Event.publish!(self, :force_create => true)
        end
      end
    end
    
    def ensure_published_event!
      # If an object has already been scraped but not triggered an event, dispatch one.
      klass = Event.event_class_for(self)
      publish_event! unless account.events.exists_for(self.id, klass).present?
    end
  end
end
