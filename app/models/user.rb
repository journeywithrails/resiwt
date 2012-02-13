class User < ActiveRecord::Base
  include Clearance::User
  
  has_many :accounts,     :class_name => "App::Account", :foreign_key => :user_id, :dependent => :destroy
  has_many :poll_entries, :class_name => "Feedback::PollEntry", :foreign_key => :user_id, :dependent => :nullify
  has_many :feedback_entries, :class_name => "Feedback::FeedbackEntry", :foreign_key => :user_id, :dependent => :nullify
  
  validates_length_of :password, :in => 6..30
  validates_presence_of :plan_id, :on => :create
  
  validates_presence_of :invitation_id, :message => 'is required', :unless => :bypass_invite?
  
  attr_accessible :plan_id, :feature_level, :invitation_token
  attr_accessor :bypass_invite
  
  has_many :sent_invitations, :class_name => "App::Invitation", :foreign_key => "sender_id"
  belongs_to :invitation, :class_name => "App::Invitation"
  
  validates_uniqueness_of :invitation_id, :message => 'has already been used to sign up', :unless => :bypass_invite?
  
  before_create :set_invitation_limit
  
  def bypass_invite?
    (bypass_invite)
  end
  
  def handle
    self.email.split("@").first rescue self.email
  end
  
  def answered_poll_ids
    self.poll_entries.collect { |e| e.answer.poll_id }.uniq
  end
  
  def refresh_accounts!
    self.accounts.each do |account|
      account.refresh!
      account.refresh_followers!
      account.refresh_friends!
    end
  end
  
  # -------------------------------
  # Spreedly helpers
  # -------------------------------
  def setup_payment!
    plan = Payment::Plan.find(self.plan_id)
    
    subscriber = Payment::Subscriber.new(:email => self.email, :customer_id => self.id)
    subscriber.save!
    
    # We have to handle setting up the payment slightly different depending on
    # whether the plan is a free plan or not.
    
    case plan.plan_type.to_sym
    when :free_trial
      # Allow the trial
      subscriber.subscribe_to_free_trial(plan)
    else
      # Need to enter card details
    end
    
    set_feature_level(subscriber.feature_level)
    
    true
  end
  
  def setup_card_details(card_details)
    invoice = Payment::Invoice.new(:subscription_plan_id => self.plan_id, :subscriber => self.subscriber)
    invoice.save!
    
    credit_card = Payment::CreditCard.new(card_details)
    
    begin
      result = invoice.pay!(credit_card)
      
      if result == true
        set_feature_level(self.subscriber.feature_level)
        invoice
      else
        false
      end
    rescue RSpreedly::Error::BadRequest
      invoice
    end
  end
  
  def cancel_subscription!
    self.subscriber.stop_auto_renew
  end
  
  def subscriber
    @subscriber ||= Payment::Subscriber.find(self.id)
  end
  
  def refresh_subscription!
    #fetch subscriber
    @subscriber = Payment::Subscriber.find(self.id)
    
    if subscriber.active
      set_feature_level(subscriber.feature_level)
    else
      set_feature_level(nil)
    end
  end
  
  def set_feature_level(type)
    self.feature_level = type
    accounts.each do |a|
      a.update_attribute(:email_notifications,email_notification_options.first) unless email_notification_options.include?(a.email_notifications)
    end
    self.save(false)
  end
  
  def active?
    !self.feature_level.blank?
  end
  
  def invitation_token
    invitation.token if invitation
  end
  
  def has_account?
    (accounts.count > 0)
  end
  
  def has_no_accounts?
    (accounts.count == 0)
  end
  
  def invitation_token=(token)
    self.invitation = App::Invitation.find_by_token(token)
  end
  
  def email_notification_options
    Configuration.options.email_notifications[self.feature_level.to_sym]
  end
  
  private
    def set_invitation_limit
      self.invitation_limit = 5
    end
  
end
