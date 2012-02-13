class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    user.setup_payment!
  end
  
  def before_destroy(user)
    # TODO: Spreedly doesn't currently support removing/flagging deleted
    # trial subscriptions. This needs updating once they do.
    raise "Could not cancel subscription for #{user.id}!" unless user.cancel_subscription!
  end
end
