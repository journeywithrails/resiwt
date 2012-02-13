class Event < ActiveRecord::Base
  belongs_to :account, :class_name => "App::Account", :foreign_key => :account_id
  validates_presence_of :object_type, :object_id, :account
  
  named_scope :recent, :limit => 100
  named_scope :exists_for, lambda { |object_id, object_type| { :conditions => ['object_id = ? AND object_type = ?', object_id, object_type] } }
  named_scope :recent_for, lambda { |object_id, object_type| { :conditions => ['object_id = ? AND object_type = ? AND created_at > ?', object_id, object_type, EMAIL_NOTIFICATION_THRESHOLD.ago] } }
  
  default_scope :order => "created_at DESC", :limit => 30
  
  EMAIL_NOTIFICATION_THRESHOLD = 5.minutes
  
  class << self
    def event_class_for(record)
      record.type.blank? ? record.class.to_s : record.type.to_s
    end
    
    def publish!(record, opts={})
      account = record.account
      raise ActiveRecord::RecordNotFound, "Can't find account to publish feed item to!" unless account
      
      silent        = opts[:silent] || false
      create_record = opts[:force_create] || record.new_record?
      send_mail     = (!event_published_recently?(account, record) && !silent && account.event_notifications? && account.in_ready_state?)
      
      if create_record
        klass_id        = record.id
        klass           = event_class_for(record)
        event_timestamp = record.respond_to?(:tweeted_at) ? record.tweeted_at : record.created_at
        
        create!(:account => account, :object_id => klass_id, :object_type => klass, :object_created_at => event_timestamp)
        
        EventMailer.deliver_notification(account, record) if send_mail
      end
    end
    
    private
    def event_published_recently?(account, record)
      events = account.events.recent_for(record.id, event_class_for(record))
      !events.empty?
    end
  end
  
  def object
    @object ||= self.object_type.constantize.find(self.object_id)
  end
  
  def object_pretty_type
    self.object_type.to_s.split("::").last.underscore rescue "event"
  end
end
