module App
  module Statistics
    class LinksController < StatisticsController

      def index
        #FIXME does not show correct information, needs to refresh each account
        @links = @account.links
      end

      def show
        @link = @account.links.find params[:id]
        @link = @link.refresh_statistics!
      end
    end
  end
end
