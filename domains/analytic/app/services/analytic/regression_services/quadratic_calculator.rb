module Analytic
  module RegressionServices
    QuadraticEquation = Struct.new(:a, :b, :c, :r)
    class QuadraticCalculatorError < StandardError; end
    class QuadraticCalculator
      include Virtus.model

      attribute :x_values, Array[Float], :writer => :private
      attribute :y_values, Array[Float], :writer => :private
      attribute :sum_x,    Float, :writer => :private
      attribute :sum_x2,   Float, :writer => :private
      attribute :sum_x3,   Float, :writer => :private
      attribute :sum_x4,   Float, :writer => :private
      attribute :sum_y,    Float, :writer => :private
      attribute :sum_xy,   Float, :writer => :private
      attribute :sum_x2_y,  Float, :writer => :private
      attribute :a,        Float, :writer => :private
      attribute :b,        Float, :writer => :private
      attribute :c,        Float, :writer => :private
      attribute :r,        Float, :writer => :private

      def initialize(x_values: Array[Float], y_values: Array[Float])
        self.x_values = x_values
        self.y_values = y_values
        validate!
      end

      def call
        regression_data_calc
        QuadraticEquation.new(a,b,c,r)
      end

      private
        def validate!
          raise QuadraticCalculatorError, 'X array or Y array cannot be null.' if x_values == nil || y_values == nil
          raise QuadraticCalculatorError, 'X array and Y array must be of same length.' if x_values.length != y_values.length
        end

        def regression_data_calc
          self.sum_x = self.sum_x2 = self.sum_x3 = self.sum_x4 = self.sum_y = self.sum_xy = self.sum_x2_y = 0.0

          (0...sample_size).each do |i|
            x = x_values[i]
            y = y_values[i]
            self.sum_x += x
            self.sum_x2 += x ** 2
            self.sum_x3 += x ** 3
            self.sum_x4 += x ** 4
            self.sum_y += y
            self.sum_xy += x * y
            self.sum_x2_y += x ** 2 * y
          end
        end

        def a
          @a ||= begin
            numerator = (sum_x ** 2 * sum_x2_y) \
                        - (sample_size * sum_x2 * sum_x2_y) \
                        - (sum_x * sum_x2 * sum_xy) \
                        + (sample_size * sum_x3 * sum_xy) \
                        + ((sum_x2 ** 2) * sum_y) \
                        - (sum_x * sum_x3 * sum_y)

            denominator = (sum_x2 ** 3) \
                      - (2 * sum_x * sum_x2 * sum_x3) \
                      + (sample_size * (sum_x3 ** 2)) \
                      + (sum_x ** 2 * sum_x4) \
                      - (sample_size * sum_x2 * sum_x4)
            (numerator / denominator).round(4)
          end
        end

        def b
          @b ||= begin
            numerator = (sample_size * sum_x2_y * sum_x3) \
                      - (sum_x * sum_x2 * sum_x2_y) \
                      + (sum_x2 ** 2 * sum_xy) \
                      + (sum_x * sum_x4 * sum_y) \
                      - (sample_size * sum_x4 * sum_xy) \
                      - (sum_x2 * sum_x3 * sum_y)


            denominator = (sum_x2 ** 3) \
                      - (2 * sum_x * sum_x2 * sum_x3) \
                      + (sample_size * sum_x3 ** 2) \
                      + (sum_x ** 2 * sum_x4) \
                      - (sample_size * sum_x2 * sum_x4)
            (numerator / denominator).round(4)
          end
        end

        def c
          @c ||= begin
            numerator = (sum_x2 ** 2 * sum_x2_y) \
                      - (sum_x * sum_x2_y * sum_x3) \
                      + (sum_x * sum_x4 * sum_xy) \
                      + (sum_x3 ** 2 * sum_y) \
                      - (sum_x2 * sum_x4 * sum_y) \
                      - (sum_x2 * sum_x3 * sum_xy)

            denominator = (sum_x2 ** 3) \
                      - (2 * sum_x * sum_x2 * sum_x3) \
                      + (sample_size * sum_x3 ** 2) \
                      + (sum_x ** 2 * sum_x4) \
                      - (sample_size * sum_x2 * sum_x4)
            (numerator / denominator).round(4)
          end
        end

        def r
          @r ||= begin
          numerator = 0.0
          denominator = 0.0
          (0...sample_size).each do |i|
            x = x_values[i]
            y = y_values[i]
            numerator += (y - (a * x ** 2 + b * x + c)) ** 2
            denominator += (y - mean_y) ** 2
          end
          Math.sqrt(1.0 - (numerator  / denominator)).round(4)
          end
        rescue
          nil
        end

        def sample_size
          @sample_size ||= x_values.length
        end

        def mean_x
          @mean_x ||= x_values.sum(0.0) / sample_size
        end

        def mean_y
          @mean_y ||= y_values.sum(0.0) / sample_size
        end

    end
  end
end
