module App
  class Invitation < ActiveRecord::Base
    belongs_to :sender, :class_name => "User"
    has_one :recipient, :class_name => "User"
    
    validates_presence_of :recipient_email
    validates_format_of :recipient_email, :with => %r{.+@.+\..+}
    
    validate :recipient_is_not_registered
    validate :sender_has_invitations, :if => :sender
    
    before_create :generate_token
    before_create :decrement_sender_count, :if => :sender
    
    def sender_email
      sender ? sender.email : 'donotreply@tweasier.com'
    end
    
    private
      def recipient_is_not_registered
        errors.add :recipient_email, 'is already registered' if User.find_by_email(recipient_email)
      end
      
      def sender_has_invitations
        unless sender.invitation_limit > 0
          error.add_to_base "You have reached your limit of invitations to send."
        end
      end
      
      def generate_token
        self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
      end
      
      def decrement_sender_count
        sender.decrement! :invitation_limit
      end
  end
end
