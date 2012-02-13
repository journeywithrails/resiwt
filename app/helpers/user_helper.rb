module UserHelper
  
  def spreedly_account_url(user)
    "#{Configuration.spreedly[Rails.env.to_sym].site_url}subscriber_accounts/#{user.subscriber.token}?return_url=#{request.url}"
  end
  
  def spreedly_upgrade_url(user)
    plan = nil
    RSpreedly::SubscriptionPlan.all.each do |sp|
      plan = sp if sp.feature_level == 'paid'
    end
    
    "#{Configuration.spreedly[Rails.env.to_sym].site_url}subscribers/#{user.id}/#{user.subscriber.token}/subscribe/#{plan.id}?return_url=#{request.url}"
  end
  
end