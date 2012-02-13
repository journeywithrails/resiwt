module App
  class AccountPresenter < Presenter
    
    def to_param
      @object.screen_name
    end
    
    def recently_created?
      @object.created_at > 1.hour.ago
    end
  end
end
