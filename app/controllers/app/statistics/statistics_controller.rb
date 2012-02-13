module App
  module Statistics
    class StatisticsController < BaseController
      before_filter :authorize_access
      
      protected
        def authorize_access
          report_name_for_auth = params[:controller].gsub('/','_').downcase.to_sym
          authorize! report_name_for_auth, :statistics, :message => "You cannot access that report with your current subscription level"
        end
    end
  end
end
