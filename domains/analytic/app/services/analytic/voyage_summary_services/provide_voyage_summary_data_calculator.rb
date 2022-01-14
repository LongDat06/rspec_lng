module Analytic
  module VoyageSummaryServices
    class ProvideVoyageSummaryDataCalculator
      DEPATURE_FLAG = '3:DEP'.freeze
      MODELING = Struct.new(
        :duration,
        :distance,
        :average_speed,
        :cargo_volume_at_port_of_arrival,
        :lng_consumption,
        :mgo_consumption,
        :average_boil_off_rate,
        :actual_heel,
        :adq,
        keyword_init: true
      )

      def initialize(imo:, voyage_no:, voyage_leg:, atd_utc:, ata_utc:)
        @imo = imo
        @voyage_no = voyage_no
        @voyage_leg = voyage_leg
        @atd_utc = atd_utc
        @ata_utc = ata_utc
      end

      def call
        MODELING.new(
          duration: duration,
          distance: distance,
          average_speed: average_speed,
          cargo_volume_at_port_of_arrival: cargo_volume_at_port_of_arrival,
          lng_consumption: lng_consumption,
          mgo_consumption: mgo_consumption,
          average_boil_off_rate: average_boil_off_rate,
          actual_heel: actual_heel,
          adq: adq
        )
      end

      private

      def ballast_voyage?
        @voyage_leg.to_s.upcase == 'B'
      end

      def landen_voyage?
        @voyage_leg.to_s.upcase == 'L'
      end

      def duration
        return if @atd_utc.blank? || @ata_utc.blank?

        @duration ||= ((@ata_utc.to_f - @atd_utc.to_f) / 1.hour).round(0)
      end

      def distance
        @distance ||= Analytic::Spas.collection.aggregate(
          [
            {
              "$match": { imo_no: @imo,
                          "spec.jsmea_voy_voyageinformation_voyageno": @voyage_no,
                          "spec.jsmea_voy_voyageinformation_leg": @voyage_leg }
            },
            {
              "$group": { "_id": '$spec.ts',
                          "distance": { "$last": '$spec.jsmea_voy_distanceandtime_day_sog' } }
            },
            {
              "$group": { "_id": nil, "total": { "$sum": '$distance' } }
            }
          ], allow_disk_use: true
        ).first.try(:[], :total)&.round(0)
      end

      def average_speed
        return if duration.nil? || duration.zero?

        @average_speed ||= (distance / duration.to_f).round(1)
      end

      def cargo_volume_at_port_of_arrival
        return if sim_data_closest_ata.nil?

        num = sim_data_closest_ata.spec['jsmea_mac_cargotk_total_volume_ave']
        num.numeric? ? num.round(0) : nil
      end

      def lng_consumption
        return if sim_data_in_closest_range_atd_ata.nil?

        sim_data_in_closest_range_atd_ata[:lng_consumption]&.round(1)
      end

      def mgo_consumption
        return if sim_data_in_closest_range_atd_ata.nil?

        sim_data_in_closest_range_atd_ata[:mgo_consumption]&.round(1)
      end

      def average_boil_off_rate
        return if !landen_voyage? || sim_data_in_closest_range_atd_ata.nil?

        sim_data_in_closest_range_atd_ata[:average_boil_off_rate]&.round(2)
      end

      def actual_heel
        return if !ballast_voyage? || sim_data_closest_atd.nil?

        num = sim_data_closest_atd.spec['jsmea_mac_cargotk_total_volume_ave']
        num.numeric? ? num.round(0) : nil
      end

      def adq
        return if !landen_voyage? || cargo_volume_at_port_of_arrival.nil? || sim_data_next_ballast_voyage.nil?

        cargo_volume_at_port_of_sim_data_next_ballast_voyage = sim_data_next_ballast_voyage.spec['jsmea_mac_cargotk_total_volume_ave']

        return if cargo_volume_at_port_of_sim_data_next_ballast_voyage.blank?
        return unless cargo_volume_at_port_of_sim_data_next_ballast_voyage.numeric?

        cargo_volume_at_port_of_arrival - cargo_volume_at_port_of_sim_data_next_ballast_voyage.round(0)
      end

      def sim_data_next_ballast_voyage
        return if @ata_utc.nil?

        @sim_data_next_ballast_voyage ||= begin
          depature = Analytic::Spas.where(
            imo_no: @imo,
            "spec.jsmea_voy_voyageinformation_category": DEPATURE_FLAG,
            "spec.jsmea_voy_voyageinformation_leg": 'B',
            "spec.jsmea_voy_dateandtime_utc": { "$gt": @ata_utc }
          ).sort({ "spec.jsmea_voy_dateandtime_utc": 1 }).first
          return nil if depature.nil?

          etd = depature.spec['jsmea_voy_dateandtime_utc']
          sim_closest_time(etd)
        end
      end

      def sim_data_closest_ata
        @sim_data_closest_ata ||= sim_closest_time(@ata_utc)
      end

      def sim_data_closest_atd
        @sim_data_closest_atd ||= sim_closest_time(@atd_utc)
      end

      def sim_data_in_closest_range_atd_ata
        return if sim_data_closest_atd.nil? || sim_data_closest_ata.nil?

        @sim_data_in_closest_range_atd_ata ||= begin
          from_time = sim_data_closest_atd.spec['ts']
          to_time = sim_data_closest_ata.spec['ts']

          match = { '$match' => {
            'imo_no' => @imo,
            'spec.ts' => { '$gte' => from_time, '$lte' => to_time }
          } }
          group_ts = {
             "$group": {
               _id: '$spec.ts',
               'jsmea_mac_ship_fg_flowcounter_fgc': {
                  '$last': '$spec.jsmea_mac_ship_fg_flowcounter_fgc'
               },
                'jsmea_mac_boiler_fgline_fg_flowcounter_fgc': {
                 '$last': '$spec.jsmea_mac_boiler_fgline_fg_flowcounter_fgc'
               },
                'jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc': {
                 '$last': '$spec.jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc'
               },
                'jsmea_mac_ship_total_include_gcu_fc': {
                 '$last': '$spec.jsmea_mac_ship_total_include_gcu_fc'
               },
                'jsmea_mac_boiler_mgoline_mgo_flowcounter_foc': {
                 '$last': '$spec.jsmea_mac_boiler_mgoline_mgo_flowcounter_foc'
               },
                'jsmea_mac_dieselgeneratorset_total_flowcounter_foc': {
                 '$last': '$spec.jsmea_mac_dieselgeneratorset_total_flowcounter_foc'
               },
                'jsmea_mac_cargotk_bor_include_fv': {
                 '$last': '$spec.jsmea_mac_cargotk_bor_include_fv'
               }
            }
          }
          group = {
            "$group": {
              _id: nil,
              lng_consumption_fields: {
                "$push": {
                  'jsmea_mac_ship_fg_flowcounter_fgc': '$jsmea_mac_ship_fg_flowcounter_fgc',
                  'jsmea_mac_boiler_fgline_fg_flowcounter_fgc': '$jsmea_mac_boiler_fgline_fg_flowcounter_fgc',
                  'jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc': '$jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc'
                }
              },
              mgo_consumption_fields: {
                "$push": {
                  'jsmea_mac_ship_fg_flowcounter_fgc': '$jsmea_mac_ship_fg_flowcounter_fgc',
                  'jsmea_mac_ship_total_include_gcu_fc': '$jsmea_mac_ship_total_include_gcu_fc',
                  'jsmea_mac_boiler_mgoline_mgo_flowcounter_foc': '$jsmea_mac_boiler_mgoline_mgo_flowcounter_foc',
                  'jsmea_mac_dieselgeneratorset_total_flowcounter_foc': '$jsmea_mac_dieselgeneratorset_total_flowcounter_foc',
                  'jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc': '$jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc'

                }
              },
              average_boil_off_rate_fields: {
                "$push": { 'jsmea_mac_cargotk_bor_include_fv': '$jsmea_mac_cargotk_bor_include_fv' }
              }
            }
          }

          project = { "$project": {
            lng_consumption_fields: 1,
            mgo_consumption_fields: 1,
            average_boil_off_rate_fields: 1
          } }
          sim_data = Analytic::Sim.collection.aggregate([match, group_ts, group, project], allow_disk_use: true).first
          return if sim_data.nil?

          {
            lng_consumption: lng_consumption_calc(sim_data['lng_consumption_fields']),
            mgo_consumption: mgo_consumption_calc(sim_data['mgo_consumption_fields']),
            average_boil_off_rate: average_boil_off_rate_calc(sim_data['average_boil_off_rate_fields'])

          }
        end
      end

      def lng_consumption_calc(lng_consumption_fields)
        if engine_xdf?
          lng_consumption_xdf_calc(lng_consumption_fields)
        else
          lng_consumption_stage_calc(lng_consumption_fields)
        end
      end

      def lng_consumption_xdf_calc(lng_consumption_fields)
        values =  lng_consumption_fields.pluck(:jsmea_mac_ship_fg_flowcounter_fgc)
        return if values.all?(&:blank?)

        result = values.map(&:to_f).sum / 24
      end

      def lng_consumption_stage_calc(lng_consumption_fields)
        a = lng_consumption_fields.pluck(:jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc)
        b = lng_consumption_fields.pluck(:jsmea_mac_boiler_fgline_fg_flowcounter_fgc)
        return if a.all?(&:blank?) && b.all?(&:blank?)

        sum_a = a.map(&:to_f).sum
        sum_b = b.map(&:to_f).sum
        (sum_a + sum_b) / 24
      end

      def mgo_consumption_calc(mgo_consumption_fields)
        if engine_xdf?
          mgo_consumption_xdf_calc(mgo_consumption_fields)
        else
          mgo_consumption_stage_calc(mgo_consumption_fields)
        end
      end

      def mgo_consumption_xdf_calc(mgo_consumption_fields)
        a = mgo_consumption_fields.pluck(:jsmea_mac_ship_fg_flowcounter_fgc)
        b = mgo_consumption_fields.pluck(:jsmea_mac_ship_total_include_gcu_fc)
        return if a.all?(&:blank?) && b.all?(&:blank?)

        sum_a = a.map(&:to_f).sum
        sum_b = b.map(&:to_f).sum
        result = (sum_b - sum_a) / 24
        return 0 if result < 0

        result
      end

      def mgo_consumption_stage_calc(mgo_consumption_fields)
        a = mgo_consumption_fields.pluck(:jsmea_mac_boiler_mgoline_mgo_flowcounter_foc)
        b = mgo_consumption_fields.pluck(:jsmea_mac_dieselgeneratorset_total_flowcounter_foc)
        c = mgo_consumption_fields.pluck(:jsmea_mac_dieselgeneratorset_fg_total_flowcounter_fgc)
        return if  a.all?(&:blank?) && b.all?(&:blank?) && c.all?(&:blank?)

        sum_a = a.map(&:to_f).sum
        sum_b = b.map(&:to_f).sum
        sum_c = c.map(&:to_f).sum

        result = (sum_a + sum_b - sum_c) / 24
        return 0 if result < 0

        result
      end

      def average_boil_off_rate_calc(average_boil_off_rate_fields)
        values = average_boil_off_rate_fields.pluck(:jsmea_mac_cargotk_bor_include_fv).reject(&:blank?)
        return if values.blank?

        values.map(&:to_f).reduce(:+).to_f / values.size
      end

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

      def vessel
        @vessel ||= Analytic::Vessel.find_by(imo: @imo)
      end

      def engine_xdf?
        vessel.engine_type.xdf?
      end
    end
  end
end
