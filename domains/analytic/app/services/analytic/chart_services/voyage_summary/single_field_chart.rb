module Analytic
  module ChartServices
    module VoyageSummary
      class SingleFieldChart
        attr_reader :imo, :voyage_no, :voyage_leg, :chart_name

        CHARTS_CLASS = {
                          Analytic::VoyageSummary::BOIL_OFF_RATE_CHART => Analytic::ChartServices::VoyageSummary::Query::AverageBoilOffRate,
                          Analytic::VoyageSummary::CARGO_VOLUMN_CHART => Analytic::ChartServices::VoyageSummary::Query::CargoVolumn,
                          Analytic::VoyageSummary::FORCING_VAPOR_COLUMN_CHART => Analytic::ChartServices::VoyageSummary::Query::ForcingVaporVolumn,
                          Analytic::VoyageSummary::AVERAGE_SPEED_CHART => Analytic::ChartServices::VoyageSummary::Query::AverageSpeed,
                          Analytic::VoyageSummary::XDF_TANK_TEMPERATURE_CHART => Analytic::ChartServices::VoyageSummary::Query::XdfTankTemperature,
                          Analytic::VoyageSummary::STAGE_TANK_TEMPERATURE_CHART => Analytic::ChartServices::VoyageSummary::Query::StageTankTemperature,
                          Analytic::VoyageSummary::STAGE_LNG_CONSUMPTION_CHART => Analytic::ChartServices::VoyageSummary::Query::StageLngConsumption,
                          Analytic::VoyageSummary::STAGE_MGO_CONSUMPTION_CHART => Analytic::ChartServices::VoyageSummary::Query::StageMgoConsumption,
                          Analytic::VoyageSummary::XDF_LNG_CONSUMPTION_CHART => Analytic::ChartServices::VoyageSummary::Query::XdfLngConsumption,
                          Analytic::VoyageSummary::XDF_MGO_CONSUMPTION_CHART => Analytic::ChartServices::VoyageSummary::Query::XdfMgoConsumption,
                        }

        MODELING = Struct.new(
          :id,
          :timestamp,
          :voyage_no,
          :average_values,
          :vessel_name,
          :selected_voyage_no,
          :view_day,
          :all_voyages,
          :voyage_props,
          keyword_init: true
        )

        def initialize(imo:, voyage_no:, voyage_leg:, chart_name:, is_positive_number: false)
          @imo = imo
          @voyage_no = voyage_no
          @voyage_leg = voyage_leg
          @chart_name = chart_name
          @is_positive_number = is_positive_number
        end

        def call
          selected_voyage = Analytic::VoyageSummary.find_by(imo: imo, voyage_no: voyage_no, voyage_leg: voyage_leg)
          return [] if selected_voyage.blank?
          voyages = selected_voyage.related_voyages
          voyages << selected_voyage
          responses = []
          all_voyages = {}
          voyage_props = []
          empty_sim_voyages = []
          common_attr = {
                          selected_voyage_no: selected_voyage.get_vessel_names.first,
                          vessel_name: selected_voyage.get_vessel_names.last
                        }
          day_attrs = {}

          voyages.each_with_index do |voyage,  index_voyage|
            next if voyage.apply_atd_utc.blank? || voyage.apply_ata_utc.blank?
            sims_data = CHARTS_CLASS[chart_name].new(voyage.imo, voyage.apply_atd_utc, voyage.apply_ata_utc).call
            all_voyages[voyage.get_vessel_names.first] = voyage.get_vessel_names.first
            voyage_props << {key: voyage.get_vessel_names.first, label: voyage.get_vessel_names.first.to_sym}
            voyage_no = voyage.get_vessel_names.first
            common_attr = common_attr.merge!({
                                              all_voyages: all_voyages,
                                              voyage_props: voyage_props
                                            })

            if sims_data.first.blank?
              empty_sim_voyages << MODELING.new(common_attr.merge!({view_day: nil, average_values: []}))
              next
            end

            first_day = sims_data.first["_id"].to_date
            sims_data.each do |sim|
              day = (sim["_id"].to_date - first_day).to_i + 1
              day_attrs[day] ||= []
              day_attrs[day] << {voyage_no: voyage_no, value: get_positive_number(sim["average_value"]), date: sim["_id"]}
            end
          end

          return empty_sim_voyages if day_attrs.keys.blank?

          day_attrs = day_attrs.sort_by{|day, data| day.to_i}.to_h
          day_attrs.each do |day, average_values|
            responses << MODELING.new(common_attr.merge!({view_day: "Day #{day}", average_values: average_values}))
          end

          responses.concat(empty_sim_voyages)
        end

        private
        def get_positive_number(value)
          return value if value.blank?
          return (@is_positive_number && value < 0 ) ? 0 : value
          return value
        end

      end
    end
  end
end
