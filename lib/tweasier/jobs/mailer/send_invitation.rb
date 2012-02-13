module Tweasier
  module Jobs
    module Mailer
      class SendInvitation
        @queue = :mailer

        class << self
          def perform(id)
            invitation = App::Invitation.find(id)
            
            App::InvitationMailer.deliver_beta_invitation(invitation)
          end
        end
      end
    end
  end
end
