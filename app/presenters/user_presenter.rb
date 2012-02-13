class UserPresenter < Presenter

  # Example usage
  #
  # MAX_SEARCHES = 10
  #
  # def can_create_searches?
  #   !(record.searches.size > MAX_SEARCHES)
  # end
  
  def free_plan?
    # TODO: this needs changing to assert whether the subscription
    # is paid or free. Free plans should have certain things
    # disabled/shown (ads).
    true
  end
  
end
