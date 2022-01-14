module Analytic
  module VoyageSummaryServices
    class ProvideVoyageClosestData
      def initialize(imo:, ata:, atd:, project: {}, group: {})
        @imo = imo
        @ata = ata
        @atd = atd
        @project = project
        @group = group
      end

      def call
        sim_data_in_closest_range_atd_ata
      end

      private

      def sim_closest_time(time)
        return if time.blank?

        where_clause = { imo_no: @imo }
        lte_cond = { "spec.ts": { "$lte": time } }
        lte_record = Analytic::Sim.where(where_clause.merge(lte_cond))
                                  .sort({ "spec.ts": -1 })
                                  .first

        gte_cond = { "spec.ts": { "$gte": time } }
        gte_record = Analytic::Sim.where(where_clause.merge(gte_cond))
                                  .sort({ "spec.ts": 1 })
                                  .first
        [lte_record, gte_record].compact.min_by { |item| (item.spec['ts'] - time).abs }
      end

      def sim_data_closest_ata
        return @sim_data_closest_ata if defined? @sim_data_closest_ata

        @sim_data_closest_ata = sim_closest_time(@ata)
      end

      def sim_data_closest_atd
        return @sim_data_closest_atd if defined? @sim_data_closest_atd

        @sim_data_closest_atd = sim_closest_time(@atd)
      end

      def sim_data_in_closest_range_atd_ata
        @sim_data_in_closest_range_atd_ata ||= begin
          return if sim_data_closest_atd.nil? || sim_data_closest_ata.nil?

          from_time = sim_data_closest_atd.spec['ts']
          to_time = sim_data_closest_ata.spec['ts']
          match = { '$match' => {
            'imo_no' => @imo,
            'spec.ts' => { '$gte' => from_time, '$lte' => to_time }
          } }
          aggregates = []
          aggregates << match
          aggregates << @group if @group.present?
          aggregates << @project if @project.present?
          Analytic::Sim.collection.aggregate(aggregates, allow_disk_use: true)
        end
      end
    end
  end
end
