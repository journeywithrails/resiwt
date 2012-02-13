module App
  class Conversation < ActiveRecord::Base
    
    belongs_to :account, :class_name => "App::Account", :foreign_key => :account_id
    
    validates_presence_of :account
    
    named_scope :between, lambda { |a, b| { :conditions => ['user_a = ? AND user_b = ?', a, b]} }
    named_scope :today, :conditions => ['created_at between ? and ?', Time.now.midnight, (Time.now.midnight + 1.day)]
    
    def validate
      if self.new_record?
        return unless self.account
      else
        return unless self.changed.include?("user_a") or self.changed.include?("user_b")
      end
      
      unless self.account.conversations.between(self.user_a, self.user_b).empty?
        errors.add_to_base("You have already created a conversation between these two people.")
      end
      
      if self.user_a.blank? and self.user_b.blank?
        errors.add_to_base("You can't have a conversation with no people!")
      elsif self.user_a.blank? or self.user_b.blank?
        errors.add_to_base("You can't have a conversation with one person!")
      end
    end
    
    def statuses
      user_a_results = Twitter::Search.new.from(self.user_a).to(self.user_b).fetch().results
      user_b_results = Twitter::Search.new.from(self.user_b).to(self.user_a).fetch().results
      
      (user_a_results | user_b_results).sort! { |a, b| b.created_at <=> a.created_at }
    end
  end
end
