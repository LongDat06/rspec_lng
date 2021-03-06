module Analytic
  module UtilityServices
    class DateRange < Range
      # step is similar to DateTime#advance argument
      def every(step, &block)
        c_time = self.begin.to_datetime
        finish_time = self.end.to_datetime
        foo_compare = self.exclude_end? ? :< : :<=

        arr = []
        while c_time.send( foo_compare, finish_time) do 
          arr << c_time
          c_time = c_time.advance(step)
        end

        return arr
      end
    end

    # Convenience method
    class RailsDateRange
      def initialize(range)
        @range = range
      end

      def call
        UtilityServices::DateRange.new(@range.begin, @range.end, @range.exclude_end?)
      end
    end
  end
end
