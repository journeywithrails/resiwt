module App
  class Retweet < App::Status
    belongs_to :original, :class_name => 'App::Status', :foreign_key => 'retweet_id'
    belongs_to :original_author, :class_name => 'App::Account', :foreign_key => 'retweet_author_id'
    
    named_scope :recent, :conditions => ['created_at > ?', 30.days]
    
    def retweet_by_me?
      self.author == self.account
    end
    
    def retweet_to_me?
      (self.author != self.account) and (self.original_author != self.account)
    end
    
    def retweet_of_me?
      self.original_author == self.account
    end
  end
end
