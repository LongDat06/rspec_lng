module Analytic
  module CleanServices
    class SpasData
      def initialize(time_period: 3.month.ago)
        @time_period = time_period
      end

      def call
        sim_in_past.destroy_all
      end

      private
      def sim_in_past
        Analytic::Spas
              .where({'spec.ts' => { 
                '$lt' => @time_period
              }})
      end
    end
  end
end
