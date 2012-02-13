module Tweasier
  module Helpers
    def self.included(controller)
      controller.send :include, Presenter
    end
  end
end
