module Analytic
  module ChartServices
    module VoyageSummary
      class SummaryChart
        attr_accessor :imo, :voyage_no, :voyage_leg, :recent_voyages

        MODELING = Struct.new(
          :id,
          :voyage_no,
          :duration,
          :distance,
          :adq,
          :average_speed,
          :lng_consumption,
          :mgo_consumption,
          :avg_boil_off_rate,
          :edq,
          :selected,
          :vessel_name,
          :actual_heel,
          :estimated_heel,
          :is_average,
          keyword_init: true
        )
        def initialize(imo, voyage_no, voyage_leg)
          @imo = imo
          @voyage_no = voyage_no
          @voyage_leg = voyage_leg
        end
        def call
          selected_voyage = Analytic::VoyageSummary.find_by(imo: imo, voyage_no: voyage_no, voyage_leg: voyage_leg)
          return [] if selected_voyage.blank?
          @recent_voyages, selected_res = related_voyages(id: selected_voyage.id, imo: selected_voyage.imo,
                                                   voyage_leg: selected_voyage.voyage_leg,
                                                   port_dept: selected_voyage.apply_port_dept,
                                                   port_arrival: selected_voyage.apply_port_arrival)
          response = []
          return [MODELING.new(response_attrs(selected_res, selected_voyage.id))] if recent_voyages.blank?
          all_voyages = recent_voyages + [{}, selected_res]

          all_voyages.map do |voyage|
            if voyage.blank?
              response << voyage; next
            end
            response << MODELING.new(response_attrs(voyage, selected_voyage.id))
          end

          avg_position = response.index({})
          response[avg_position] = MODELING.new(parse_average(selected_res))
          response
        end

        private

        def parse_average(selected_voyage)
          parse_res = {}
          recent_voyages.each do |voy|
            parse_res[:durations] ||= []
            parse_res[:distances] ||= []
            parse_res[:speeds] ||= []
            parse_res[:adq] ||= []
            parse_res[:lng_consumption] ||= []
            parse_res[:mgo_consumption] ||= []
            parse_res[:average_boil_off_rates] ||= []
            parse_res[:edq] ||= []
            parse_res[:actual_heels] ||= []
            parse_res[:estimated_heels] ||= []

            parse_res[:durations] << voy["apply_duration"]
            parse_res[:distances] << voy["apply_distance"]
            parse_res[:speeds] << voy["apply_average_speed"]
            parse_res[:adq] << voy["adq"]
            parse_res[:lng_consumption] << voy["lng_consumption"]
            parse_res[:mgo_consumption] << voy["mgo_consumption"]
            parse_res[:average_boil_off_rates] << voy["average_boil_off_rate"]
            parse_res[:edq] << voy["estimated_edq"]
            parse_res[:actual_heels] << voy["actual_heel"]
            parse_res[:estimated_heels] << voy["estimated_heel"]
          end

          {
            voyage_no: 'Ave.',
            duration: calculate_avg( parse_res[:durations].without([nil, ""]) ),
            distance: calculate_avg( parse_res[:distances].without([nil, ""]) ),
            average_speed: calculate_avg( parse_res[:speeds].without([nil, ""]) ),
            adq: calculate_avg( parse_res[:adq].without([nil, ""]) ),
            lng_consumption: calculate_avg( parse_res[:lng_consumption].without([nil, ""]) ),
            mgo_consumption: calculate_avg( parse_res[:mgo_consumption].without([nil, ""]) ),
            avg_boil_off_rate: calculate_avg( parse_res[:average_boil_off_rates].without([nil, ""]) ),
            edq: calculate_avg( parse_res[:edq].without([nil, ""]) ),
            actual_heel: calculate_avg( parse_res[:actual_heels].without([nil, ""]) ),
            estimated_heel: calculate_avg( parse_res[:estimated_heels].without([nil, ""]) ),
            vessel_name: selected_voyage.get_vessel_names.last,
            selected: false,
            is_average: true
          }
        end

        def response_attrs(voyage, selected_voyage_id)
          return {} if voyage.blank?
          {
            id: voyage["id"],
            voyage_no: voyage.get_vessel_names.first,
            duration: voyage["apply_duration"],
            distance: voyage["apply_distance"],
            adq: voyage["adq"],
            average_speed: voyage["apply_average_speed"],
            lng_consumption: voyage["lng_consumption"],
            mgo_consumption: voyage["mgo_consumption"],
            avg_boil_off_rate: voyage["average_boil_off_rate"],
            edq: voyage["estimated_edq"],
            vessel_name: voyage.get_vessel_names.last,
            actual_heel: voyage["actual_heel"],
            estimated_heel: voyage["estimated_heel"],
            selected: voyage.id == selected_voyage_id,
            is_average: false
          }
        end

        def calculate_avg(arrs)
          return nil if arrs.blank?
          arrs.sum/arrs.size
        end

        def related_voyages(id:, imo:, voyage_leg:, port_dept:, port_arrival:)
          all_records = Analytic::VoyageSummary.with_edq_resuls
                            .where(imo: imo, voyage_leg: voyage_leg)
          all_records = all_records.where("COALESCE(manual_port_dept, port_dept) = ?", port_dept) if port_dept.present?
          all_records = all_records.where("COALESCE(manual_port_arrival, port_arrival) = ?", port_arrival) if port_arrival.present?
          all_records = all_records.where("COALESCE(manual_port_dept, port_dept) IS NULL") if port_dept.nil?
          all_records = all_records.where("COALESCE(manual_port_arrival, port_arrival) IS NULL") if port_arrival.nil?
          voyages = all_records.where("analytic_voyage_summaries.id <> #{id}").order("COALESCE(manual_atd_utc, atd_utc) DESC, voyage_no asc").limit(5)

          selected_voyage = all_records.find_by_id id

          [voyages, selected_voyage]
        end
      end
    end
  end
end
