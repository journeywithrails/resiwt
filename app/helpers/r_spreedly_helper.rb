module RSpreedlyHelper
  def plan_and_price(plan)
    return_str = plan.name
    return_str << " - &pound;#{"%.2f" % plan.price}" if plan.price > 0
    return_str
  end
end