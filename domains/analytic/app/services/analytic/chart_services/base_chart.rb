module Analytic
  module ChartServices
    class BaseChart
      def initialize(from_time, to_time, imo, closest_at)
        @from_time = from_time.to_datetime
        @to_time = to_time.to_datetime
        @imo = imo.to_i
        @closest_at = closest_at.present? ? closest_at.to_datetime : nil
      end

      protected
      def matched
        {
          "$match" => {
            "$and" => [
              "spec.ts" => { "$gte" => @from_time, "$lte" => @to_time },
              "imo_no" => @imo
            ]
          }
        }
      end

      def sort
        {
          "$sort" => @closest_at.present? ? { "difference" => 1 } : { "spec.ts" => 1 }
        }
      end

      def limit
        { "$limit" => @closest_at.present? ? 1 : 9999999 }
      end

      def group
        {
          "$group" => {
            "_id" => { "hour" => { "$hour" => "$spec.ts"}, "day" => { "$dayOfMonth" => "$spec.ts"}, "month" => { "$month" => "$spec.ts"}, "year" => { "$year" => "$spec.ts" } },
            "spec" => {"$last" => '$spec'},
          }
        }
      end

      def unwind
        { "$unwind" => "$spec" }
      end

      def difference_project
        {
          "difference" => {
            "$abs" => {
              "$subtract" => [@closest_at, "$spec.ts"]
            }
          },
        }
      end
    end
  end
end
