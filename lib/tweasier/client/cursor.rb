module Tweasier
  module Client
    class Cursor
      attr_accessor :value, :next_value
      FIRST_PAGE = -1
      
      def initialize(value=nil)
        self.value = value || FIRST_PAGE
      end
      
      def to_s
        self.value
      end
      
      def first_page?
        self.value == FIRST_PAGE
      end
      
      def first_page
        FIRST_PAGE
      end
      
      def has_next?
        (self.next_value != 0) && (self.next_value != self.value)
      end
    end
  end
end
