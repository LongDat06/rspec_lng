module Analytic
  module VoyageSummaryServices
    class SeasonalVoyageSummary
      attr_accessor :imos, :dept_ports, :arrival_ports, :dept_years, :dept_months, :voyage_ids
      MODELING_VOYAGE = Struct.new( :id,
                                    :imo,
                                    :voyage_no,
                                    :atd_utc,
                                    :ata_utc,
                                    :vessel_name,
                                    :closest_atd,
                                    :closest_ata,
                                    keyword_init: true
                                  )

      MODELING_CHART = Struct.new(  :id,
                                    :duration,
                                    :distance,
                                    :average_speed,
                                    :mgo_consumption,
                                    :tooltip_duration,
                                    :tooltip_distance,
                                    :tooltip_average_speed,
                                    :tooltip_mgo_consumption,
                                    keyword_init: true
                                  )

      def initialize(imos:, dept_ports:, arrival_ports:, dept_years:, dept_months:, voyage_ids:)
        @imos = imos.to_s.split(",")
        @dept_ports = dept_ports.to_s.split(",")
        @arrival_ports = arrival_ports.to_s.split(",")
        @dept_years = dept_years.to_s.split(",")
        @dept_months =dept_months.to_s.split(",")
        @voyage_ids = voyage_ids.to_s.split(",")
      end

      def call
        check_missing_params
        voyages = fetch_voyages
        response_voyages = []
        response_chart = {}
        return [] if voyages.blank?
        voyages.map do |voyage|
          closest_atd = voyage["apply_atd_utc"].blank? ? voyage["apply_ata_utc"] - 30.days : nil
          closest_ata = voyage["apply_ata_utc"].blank? ? voyage["apply_atd_utc"] + 30.days : nil
          vessel_name = voyage["vessel_name"]
          voyage_no = voyage["full_voyage_no"]
          response_voyages << MODELING_VOYAGE.new(id: voyage.id,
                                          imo: voyage["imo"],
                                          vessel_name: vessel_name,
                                          voyage_no: voyage_no,
                                          atd_utc: voyage["apply_atd_utc"],
                                          ata_utc: voyage["apply_ata_utc"],
                                          closest_atd: closest_atd,
                                          closest_ata: closest_ata)
          response_chart[:duration] ||= []
          response_chart[:distance] ||= []
          response_chart[:average_speed] ||= []
          response_chart[:mgo_consumption] ||= []
          response_chart[:duration] << {vessel_name: vessel_name, voyage_no: voyage_no, value: voyage["apply_duration"]}
          response_chart[:distance] << {vessel_name: vessel_name, voyage_no: voyage_no, value: voyage["apply_distance"]}
          response_chart[:average_speed] << {vessel_name: vessel_name, voyage_no: voyage_no, value: voyage["apply_average_speed"]}
          response_chart[:mgo_consumption] << {vessel_name: vessel_name, voyage_no: voyage_no, value: voyage.mgo_consumption}

        end
        data_chart = MODELING_CHART.new( duration: calculate_avg(response_chart[:duration].map{|voyage| voyage[:value]}),
                      distance: calculate_avg(response_chart[:distance].map{|voyage| voyage[:value]}),
                      average_speed: calculate_avg(response_chart[:average_speed].map{|voyage| voyage[:value]}, 1),
                      mgo_consumption: calculate_avg(response_chart[:mgo_consumption].map{|voyage| voyage[:value]}, 1),
                      tooltip_duration: response_chart[:duration],
                      tooltip_distance: response_chart[:distance],
                      tooltip_average_speed: response_chart[:average_speed],
                      tooltip_mgo_consumption: response_chart[:mgo_consumption] )
        [response_voyages, data_chart]
      end

      private

      def parse_years_months(years, months)
        datetimes = []
        months.each do |month|
          years.each do |year|
            datetimes << "#{month} #{year}".to_date
          end
        end
        datetimes
      end

      def conds_with_atd(datetimes)
        conds = []
        datetimes.each do |dtime|
          beginning_of_month = dtime.beginning_of_month.beginning_of_day
          end_of_month = dtime.end_of_month.end_of_day
          conds << "(COALESCE(manual_atd_utc, atd_utc) BETWEEN '#{beginning_of_month}' AND '#{end_of_month}')"
        end
        conds.join(" OR ")
      end

      def check_missing_params
          limits = {vessel: 4, dept_ports: 5, arrival_ports: 5, dept_years: 5, dept_months: 3}
          missing_params = []
          invalid_params = []
          errors = []
          missing_params << "Vessel" unless imos.present?
          missing_params << "Departure Year" if dept_years.blank? && voyage_ids.blank?
          missing_params << "Departure Month" if dept_months.blank? && voyage_ids.blank?

          invalid_params << [:vessel, "Vessels"] if imos.size > limits[:vessel]
          invalid_params << [:dept_years, "Departure Years"] if dept_years.size > limits[:dept_years]
          invalid_params << [:dept_months, "Departure Months"] if dept_months.size > limits[:dept_months]
          invalid_params << [:dept_ports, "Departure Ports"] if dept_ports.size > limits[:dept_ports]
          invalid_params << [:arrival_ports, "Arrival Ports"] if arrival_ports.size > limits[:arrival_ports]

          errors << "#{missing_params.join(', ')} can't be blank" if missing_params.present?
          invalid_params.each do |invalid_key|
            errors << "The number of #{invalid_key.last} can not be over #{limits[invalid_key.first]}"
          end

          raise errors.join(", ") if errors.present?
        end

        def calculate_avg(arrs, round_number = 0)
          return nil if arrs.blank?
          without_blank_arrs =  arrs.without([nil, ""])
          return nil if without_blank_arrs.blank?
          (without_blank_arrs.sum/arrs.size.to_f).round(round_number)
        end

        protected

        def fetch_voyages
          voyages = Analytic::VoyageSummary.joins(:vessel).select("analytic_voyage_summaries.id, analytic_voyage_summaries.imo,
                                                                  COALESCE(analytic_voyage_summaries.manual_atd_utc, analytic_voyage_summaries.atd_utc) as apply_atd_utc,
                                                                  COALESCE(analytic_voyage_summaries.manual_ata_utc, analytic_voyage_summaries.ata_utc) as apply_ata_utc,
                                                                  COALESCE(analytic_voyage_summaries.manual_distance, analytic_voyage_summaries.distance) as apply_distance,
                                                                  COALESCE(analytic_voyage_summaries.manual_duration, analytic_voyage_summaries.duration) as apply_duration,
                                                                  COALESCE(analytic_voyage_summaries.manual_average_speed, analytic_voyage_summaries.average_speed) as apply_average_speed,
                                                                  concat(voyage_no, voyage_leg) as full_voyage_no,
                                                                  vessels.name as vessel_name, duration, distance, average_speed, mgo_consumption")
                                                          .order(voyage_no: :desc, voyage_leg: :desc)

          voyages = voyages.where("analytic_voyage_summaries.imo IN (?)", imos) if imos.present?
          if voyage_ids.present?
              voyages = voyages.where("analytic_voyage_summaries.id IN (?)", voyage_ids)
          else
            voyages = voyages.where("COALESCE(manual_port_dept, port_dept) IN (?) OR port_dept IS NULL", dept_ports) if dept_ports.present? && dept_ports.include?("-")
            voyages = voyages.where("COALESCE(manual_port_dept, port_dept) IN (?)", dept_ports) if dept_ports.present? && !dept_ports.include?("-")
            voyages = voyages.where("COALESCE(manual_port_arrival, port_arrival) IN (?)", arrival_ports) if arrival_ports.present? && !arrival_ports.include?("-")
            voyages = voyages.where("COALESCE(manual_port_arrival, port_arrival) IN (?) OR port_arrival IS NULL", arrival_ports) if arrival_ports.present? && arrival_ports.include?("-")
            if dept_years.present? && dept_months.present?
              datetimes = parse_years_months(dept_years, dept_months)
              voyages = voyages.where(conds_with_atd(datetimes))
            end
          end
          voyages
        end
    end
  end
end
