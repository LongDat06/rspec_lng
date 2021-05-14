module Analytic
  module CleanServices
    class SimData
      def initialize(time_period: 1.month.ago)
        @time_period = time_period
      end

      def call
        sim_in_past.destroy_all
      end

      private
      def sim_in_past
        Analytic::Sim
              .where({'spec.ts' => { 
                '$lt' => @time_period
              }})
      end
    end
  end
end
