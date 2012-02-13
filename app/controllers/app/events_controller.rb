module App
  class EventsController < BaseController
    
    def index
      @events = @account.events.all
    end
  end
end
