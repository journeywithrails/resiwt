class EventMailer < BaseMailer
  helper :events, :status
  
  def notification(account, record)
    setup_mail(account.user.email)
    @subject += "Alert"
    @body    = { :account => account, :record => record }
  end
  
end
