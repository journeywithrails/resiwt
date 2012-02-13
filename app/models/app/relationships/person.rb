module App
  module Relationships
    class Person < ActiveRecord::Base
      set_table_name :relationships
      
      validates_uniqueness_of :to_account_id, :scope => [:type, :from_account_id]
      validates_uniqueness_of :from_account_id, :scope => [:type, :to_account_id]
      
      validates_presence_of :from_account
      validates_presence_of :to_account
      
      belongs_to :search,  :class_name => "App::Search",  :foreign_key => :search_id
      belongs_to :from_account, :class_name => "App::Account"
      belongs_to :to_account, :class_name => "App::Account"
      
      delegate :screen_name,
               :name,
               :location,
               :profile_image_url,
               :name,
               :description,
               :timestamp,
               :url,
               :influence,
               :twitter_id, :to => :to_account
      
      named_scope :recent, :order => "created_at DESC", :limit => 30
      
      before_create :initialize_last_synced_at
      
      def initialize_last_synced_at
        self.last_synced_at = Time.zone.now
      end
      
      def self.touch_synced_timestamp_for(twitter_ids)
        self.connection.execute("UPDATE relationships
                                 SET relationships.last_synced_at = '#{Time.zone.now.to_s(:db)}'
                                 WHERE relationships.to_account_id IN (
                                   SELECT accounts.id
                                   FROM accounts
                                   WHERE accounts.twitter_id IN (#{twitter_ids.join(',')}))
                                 AND type = '#{self.to_s}'")
      end
      
      def self.sorted(type=nil, options={})
        account    = options[:account]
        includes   = [:to_account]
        conditions = []
        joins      = ""
        filter     = nil
        
        order = case type.to_sym
                when :influence_ascending
                  "accounts.influence ASC"
                when :influence_descending
                  "accounts.influence DESC"
                when :ascending
                  "accounts.screen_name ASC"
                when :descending
                  "accounts.screen_name DESC"
                when :recent
                  "relationships.created_at DESC"
                when :active
                  joins      = "LEFT JOIN statuses ON statuses.author_id = relationships.to_account_id"
                  conditions = ["statuses.updated_at > ?", Configuration.sorting.inactivity_period.days.ago]
                  filter     = :screen_name
                  "statuses.created_at DESC"
                when :dormant
                  joins      = "LEFT JOIN statuses ON statuses.author_id = relationships.to_account_id"
                  conditions = ["statuses.updated_at < ?", Configuration.sorting.inactivity_period.days.ago]
                  filter     = :screen_name
                  "statuses.created_at DESC"
                when :statuses_ascending
                  "relationships.statuses_count ASC"
                when :statuses_descending
                  "relationships.statuses_count DESC"
                when :followers_ascending
                  "relationships.followers_count ASC"
                when :followers_descending
                  "relationships.followers_count DESC"
                when :friends_ascending
                  "relationships.friends_count ASC"
                when :friends_descending
                  "relationships.friends_count DESC"
                when :friends_not_following_ascending
                  conditions = "relationships.from_account_id = #{account.id}
                                AND relationships.type = 'App::Relationships::Friend'
                                AND relationships.to_account_id NOT IN (SELECT b.to_account_id
                                                                        FROM relationships b
                                                                        WHERE b.from_account_id = #{account.id}
                                                                        AND b.type = 'App::Relationships::Follower')"
                  "accounts.screen_name ASC"
                when :friends_not_following_descending
                  conditions = "relationships.from_account_id = #{account.id}
                                AND relationships.type = 'App::Relationships::Friend'
                                AND relationships.to_account_id NOT IN (SELECT b.to_account_id
                                                                        FROM relationships b
                                                                        WHERE b.from_account_id = #{account.id}
                                                                        AND b.type = 'App::Relationships::Follower')"
                  "accounts.screen_name DESC"
                when :following_not_friends_ascending
                  return find_by_sql "SELECT * FROM relationships
                                      INNER JOIN accounts a
                                      ON a.id = relationships.to_account_id
                                      WHERE relationships.from_account_id = #{account.id}
                                      AND relationships.type = 'App::Relationships::Follower'
                                      AND relationships.to_account_id NOT IN (SELECT b.to_account_id
                                                                              FROM relationships b
                                                                              WHERE b.from_account_id = #{account.id}
                                                                              AND b.type = 'App::Relationships::Friend')
                                      ORDER BY a.screen_name ASC"
                when :following_not_friends_descending
                  return find_by_sql "SELECT * FROM relationships
                                      INNER JOIN accounts a
                                      ON a.id = relationships.to_account_id
                                      WHERE relationships.from_account_id = #{account.id}
                                      AND relationships.type = 'App::Relationships::Follower'
                                      AND relationships.to_account_id NOT IN (SELECT b.to_account_id
                                                                              FROM relationships b
                                                                              WHERE b.from_account_id = #{account.id}
                                                                              AND b.type = 'App::Relationships::Friend')
                                      ORDER BY a.screen_name DESC"
                when :mutual_friends_ascending
                  return account.mutual_friends("ASC")
                when :mutual_friends_descending
                  return account.mutual_friends("DESC")
                else
                  "relationships.created_at DESC"
                end
        
        sorted = all(:order => order, :include => includes, :conditions => conditions, :joins => joins).paginate(options.merge!(:per_page => self.per_page))
        sorted = filter ? sorted.uniq(&filter) : sorted
        sorted
      end
      
      def self.search(term=nil, options={})
        return [] unless term
        
        term       = "%#{term}%"
        order      = "accounts.screen_name ASC"
        conditions = ['accounts.screen_name LIKE ? OR name LIKE ? OR location LIKE ?', term, term, term]
        
        all(:order => order, :include => [:to_account], :conditions => conditions).paginate(options.merge!(:per_page => self.per_page))
      end
      
      def self.per_page
        30
      end
      
      def following?
        mutual_follow
      end
      
      def from_mash!(mash, opts={})
        self.to_account = App::Account.find_or_initialize_by_twitter_id(mash.id)
        
        self.to_account.from_mash!(mash)
        self.to_account.save!
        
        self.followers_count = mash.followers_count
        self.mutual_follow   = mash.following
        self.friends_count   = mash.friends_count
        self.statuses_count  = mash.statuses_count
        self.search_id       = opts[:search_id] if opts[:search_id]
        
        self.attributes.merge!(opts)
        self
      end
    end
  end
end
