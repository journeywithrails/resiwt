module AccountHelper
  
  def account_notices(account)
    render :partial => "app/accounts/notices", :locals => { :account => account }
  end
  
  def format_influence(account)
    influence = account.respond_to?(:influence) ? account.influence : 0
    number_with_delimiter(number_with_precision(influence, :precision => 0))
  end
end
