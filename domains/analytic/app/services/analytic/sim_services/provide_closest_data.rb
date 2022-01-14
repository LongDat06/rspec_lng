module Analytic
  module SimServices
    class ProvideClosestData
      def initialize(imo:, time:)
        @imo = imo
        @time = time
      end

      def call
        sim_closest_time
      end

      private

      def sim_closest_time
        return if @time.blank?

        where_clause = { imo_no: @imo }
        lte_cond = { "spec.ts": { "$lte": @time } }
        lte_record = Analytic::Sim.where(where_clause.merge(lte_cond))
                                  .sort({ "spec.ts": -1 })
                                  .first

        gte_cond = { "spec.ts": { "$gte": @time } }
        gte_record = Analytic::Sim.where(where_clause.merge(gte_cond))
                                  .sort({ "spec.ts": 1 })
                                  .first
        [lte_record, gte_record].compact.min_by { |item| (item.spec['ts'] - @time).abs }
      end
    end
  end
end
