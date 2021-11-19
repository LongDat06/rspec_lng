module Analytic
  module InterpolationServices
    class LinearCalculatorError < StandardError; end
    class LinearCalculator
      include Virtus.model

      attribute :x_values, Array[Float], :writer => :private
      attribute :y_values, Array[Float], :writer => :private

      def initialize(x_values: Array[Float], y_values: Array[Float])
        self.x_values = x_values
        self.y_values = y_values
        validate!
      end

      def call(x: Float)
        arr = x_values.zip(y_values).sort
        smallest_x1 = arr.first[0]
        if(x < smallest_x1)
          points = arr.first(2)
          return interpolation_calc(points[0], points[1], x)
        end
        largest_x1 = arr.last[0]
        if(x > largest_x1)
          points = arr.last(2)
          return interpolation_calc(points[0], points[1], x)
        end

        (0...arr.length - 1).each do |i|
          x2 = arr[i+1][0]
          if ( x2 >= x)
            return interpolation_calc(arr[i], arr[i+1], x)
          end
        end
        raise LinearCalculatorError, 'Something went wrong. An interpolation value cannot be calculated.'
      end

      private
        def validate!
          raise LinearCalculatorError, 'X array or Y array cannot be blank.' if x_values.blank? || y_values.blank?
          raise LinearCalculatorError, 'X array and Y array must be of same length.' if x_values.length != y_values.length
        end

        def interpolation_calc(point1, point2, x)
           x1 = point1[0]
           y1 = point1[1]
           x2 = point2[0]
           y2 = point2[1]
           return interpolation_formular_calc(x1, y1, x2, y2, x)
        end

        def interpolation_formular_calc(x1, y1, x2, y2, x)
          return y1 + (y2 - y1) / (x2- x1) * (x - x1)
        end
    end
  end
end
