module App
  class InvitationMailer < BaseMailer
    
    def beta_invitation(invitation)
      setup_mail(invitation.recipient_email)
      
      from        invitation.sender_email
      subject     "Tweasier Invite"
      @body        = {:invitation => invitation}
      
      invitation.update_attribute(:sent_at, Time.now)
    end
  end
end
