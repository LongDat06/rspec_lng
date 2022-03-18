module Analytic
  module ChartServices
    module VoyageSummary
      class StageTankTemperatureChart
        attr_reader :voyage_id

        MODELING = Struct.new(
          :id,
          :timestamp,
          :voyage_no,
          :avg_cargotk1,
          :avg_cargotk2,
          :avg_cargotk3,
          :avg_cargotk4,
          :count,
          :vessel_name,
          :selected_voyage_no,
          :all_voyages,
          :voyage_props,
          :view_day,
          keyword_init: true
        )

        def initialize(voyage_id:, chart_name: nil)
          @voyage_id = voyage_id
        end

        def call
          selected_voyage = Analytic::VoyageSummary.find_by_id voyage_id
          return [] if selected_voyage.blank?
          voyages = selected_voyage.related_voyages(2)
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
            sims_data = Query::StageTankTemperature.new(voyage.imo, voyage.apply_atd_utc, voyage.apply_ata_utc).call
            all_voyages[voyage.get_vessel_names.first] = voyage.get_vessel_names.first
            voyage_props << {key: voyage.get_vessel_names.first, label: voyage.get_vessel_names.first.to_sym}
            voyage_no = voyage.get_vessel_names.first
            common_attr = common_attr.merge!({
                                              all_voyages: all_voyages,
                                              voyage_props: voyage_props,
                                            })

            if sims_data.first.blank?
              empty_sim_voyages << MODELING.new(common_attr.merge!({view_day: nil,
                                                                    avg_cargotk1: [],
                                                                    avg_cargotk2: [],
                                                                    avg_cargotk3: [],
                                                                    avg_cargotk4: []}))
              next
            end

            first_day = sims_data.first["_id"].to_date
            sims_data.each do |sim|
              day = (sim["_id"].to_date - first_day).to_i + 1
              day_attrs[day] ||= {}
              day_attrs[day][:avg_cargotk1] ||= []
              day_attrs[day][:avg_cargotk2] ||= []
              day_attrs[day][:avg_cargotk3] ||= []
              day_attrs[day][:avg_cargotk4] ||= []

              day_attrs[day][:avg_cargotk1] << {voyage_no: voyage_no, value: sim["avg_cargotk1"], date: sim["_id"]}
              day_attrs[day][:avg_cargotk2] << {voyage_no: voyage_no, value: sim["avg_cargotk2"], date: sim["_id"]}
              day_attrs[day][:avg_cargotk3] << {voyage_no: voyage_no, value: sim["avg_cargotk3"], date: sim["_id"]}
              day_attrs[day][:avg_cargotk4] << {voyage_no: voyage_no, value: sim["avg_cargotk4"], date: sim["_id"]}
            end
          end

          return empty_sim_voyages if day_attrs.keys.blank?
          day_attrs = day_attrs.sort_by{|day, data| day.to_i}.to_h
          day_attrs.each do |day, average_values|
            responses << MODELING.new(common_attr.merge!({view_day: "Day #{day}"}.merge!(average_values)))
          end

          responses.concat(empty_sim_voyages)
        end

      end
    end
  end
end
