module Tweasier
  module Helpers
    module Presenter
      
      def presenter_for(obj, opts={})
        presenter = "#{obj.class.to_s}Presenter".constantize
        presenter.new(obj, opts)
      end
    end
  end
end
