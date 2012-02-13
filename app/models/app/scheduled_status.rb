module App
  class ScheduledStatus < ActiveRecord::Base
    
    belongs_to :account, :class_name => "App::Account", :foreign_key => :account_id
    
    validates_presence_of :text, :publish_date, :account
    validates_length_of :text, :maximum => 140
    
    VALIDATION_TIME_GAP = 10.freeze
    
    named_scope :published, :conditions => { :published => true }
    named_scope :pending,   :conditions => { :published => false }
    named_scope :queued,    :conditions => ['published = ? AND publish_date < ?', false, Time.now]
    named_scope :around, lambda { |time| { :conditions => ['publish_date > ? AND publish_date < ? AND published = ?', time - VALIDATION_TIME_GAP.minutes, time + VALIDATION_TIME_GAP.minutes, false] } }
    named_scope :for_date, lambda { |pdate| { :conditions => ['publish_date between ? AND ?', pdate.midnight, (pdate.midnight + 1.day)] } }
    
    def validate
      errors.add_to_base "Publish date must be in the future!" unless self.publish_date and self.publish_date.to_time > Time.now
      errors.add_to_base "There seems to be another status update scheduled around the same time as this one. To prevent from abuse we dont allow statuses to be scheduled less than #{VALIDATION_TIME_GAP} minutes apart." if other_scheduled_status_exists_within_timeframe?
    end
    
    def publish!
      return if self.published?
      
      self.account.client.update(self.text)
      self.published = true
      self.save(false)
    end
    
    private
    def other_scheduled_status_exists_within_timeframe?
      return false unless self.account and self.publish_date
      
      statuses = self.account.scheduled_statuses.around(self.publish_date.to_time)
      
      unless self.new_record?
        return false if (statuses.size == 1) and (statuses.first == self)
      end
      
      statuses.present?
    end
  end
end
