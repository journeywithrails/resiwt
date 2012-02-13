module App
  class Search < ActiveRecord::Base
    belongs_to :account,  :class_name => "App::Account",         :foreign_key => :account_id
    has_many :conditions, :class_name => "App::SearchCondition", :foreign_key => :search_id, :dependent => :destroy
    has_many :friends,    :class_name => "App::Relationships::Friend", :foreign_key => :search_id
    has_many :unfollowed, :class_name => "App::Relationships::Unfollowed", :foreign_key => :search_id, :dependent => :nullify
    has_many :statuses, :class_name => "App::Status", :foreign_key => :search_id, :dependent => :destroy
    
    validates_presence_of :account, :title
    validates_uniqueness_of :title, :scope => :account_id
    
    named_scope :today, :conditions => ['created_at between ? and ?', Time.now.midnight, (Time.now.midnight + 1.day)]
    
    # This method turns the conditions into a tasty search string
    def parameterize
      terms = []
      
      self.conditions.each do |condition|
        terms << condition.parameterize
      end
      
      terms.empty? ? "" : terms.join(" ")
    end
    
  end
end
