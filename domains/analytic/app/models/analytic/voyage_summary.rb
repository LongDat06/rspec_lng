module Analytic
  class VoyageSummary < ApplicationRecord
    belongs_to :edq_results, class_name: Analytic::EdqResult.name, foreign_key: :analytic_edq_results_id, optional: true
    belongs_to :vessel, class_name: :Vessel, foreign_key: :imo, primary_key: :imo

    validates_presence_of :imo, :voyage_no, :voyage_leg
    validates_uniqueness_of :imo, scope: %i[voyage_no voyage_leg]

    scope :dept_ports, lambda {
      where.not(port_dept: nil).order(:port_dept).distinct.pluck(:port_dept)
    }

    scope :arrival_ports, lambda {
      where.not(port_arrival: nil).order(:port_arrival).distinct.pluck(:port_arrival)
    }

    scope :with_edq_resuls, lambda {
      joins_edq_results.select('analytic_voyage_summaries.*,
                                COALESCE(analytic_voyage_summaries.manual_distance, analytic_voyage_summaries.distance) as apply_distance,
                                COALESCE(analytic_voyage_summaries.manual_duration, analytic_voyage_summaries.duration) as apply_duration,
                                COALESCE(analytic_voyage_summaries.manual_average_speed, analytic_voyage_summaries.average_speed) as apply_average_speed,
                                analytic_edq_results.heel as estimated_heel,
                                analytic_edq_results.edq as estimated_edq')
    }

    scope :joins_edq_results, lambda {
      joins(<<~SQL)
        LEFT JOIN analytic_edq_results
        ON analytic_voyage_summaries.imo = analytic_edq_results.imo AND analytic_edq_results.finalized = 't'
          AND ((analytic_voyage_summaries.voyage_leg = 'B' AND
                analytic_voyage_summaries.voyage_no = analytic_edq_results.ballast_voyage_no)
                OR (analytic_voyage_summaries.voyage_leg = 'L'
                    AND analytic_voyage_summaries.voyage_no = analytic_edq_results.laden_voyage_no))
      SQL
    }

    DEFAULT_NUMBER_VOYAGE = 5
    BOIL_OFF_RATE_CHART = "AverageBoilOffRate"
    CARGO_VOLUMN_CHART = "CargoVolumn"
    FORCING_VAPOR_COLUMN_CHART = "ForcingVaporVolumn"
    AVERAGE_SPEED_CHART = "AverageSpeed"
    XDF_TANK_TEMPERATURE_CHART = "XdfTankTemperature"
    STAGE_TANK_TEMPERATURE_CHART = "StageTankTemperature"
    STAGE_LNG_CONSUMPTION_CHART = "StageLngConsumption"
    STAGE_MGO_CONSUMPTION_CHART = "StageMgoConsumption"
    XDF_LNG_CONSUMPTION_CHART = "XdfLngConsumption"
    XDF_MGO_CONSUMPTION_CHART = "XdfMgoConsumption"

    def laden_voyage?
      voyage_leg == 'L'
    end

    def ballast_voyage?
      voyage_leg == 'B'
    end

    def vessel_name
      read_attribute('vessel_name') || vessel&.name
    end

    def voyage_name
      read_attribute('voyage_name') || [voyage_no, voyage_leg].join
    end

    def estimated_heel
      read_attribute('estimated_heel') if ballast_voyage?
    end

    def estimated_edq
      read_attribute('estimated_edq') if laden_voyage?
    end

    def atd_lt_display
      atd_lt&.strftime(I18n.t('analytic.format_datetime'))
    end

    def ata_lt_display
      ata_lt&.strftime(I18n.t('analytic.format_datetime'))
    end

    def related_voyages(number_of_voyage = DEFAULT_NUMBER_VOYAGE)
      all_records = self.class.where(imo: self.imo, voyage_leg: self.voyage_leg)
      all_records = all_records.where("COALESCE(manual_port_dept, port_dept) = ?", self.apply_port_dept) if self.apply_port_dept.present?
      all_records = all_records.where("COALESCE(manual_port_arrival, port_arrival) = ?", self.apply_port_arrival) if self.apply_port_arrival.present?
      all_records = all_records.where("COALESCE(manual_port_dept, port_dept) IS NULL") if self.apply_port_dept.nil?
      all_records = all_records.where("COALESCE(manual_port_arrival, port_arrival) IS NULL") if self.apply_port_arrival.nil?
      all_records = all_records.where.not(id: self.id).order("COALESCE(manual_atd_utc, atd_utc) DESC, voyage_no asc").limit(number_of_voyage)
      all_records.to_a
    end

    def get_vessel_names
      capitalize_name = self.vessel.name.split(" ").map(&:chr).join("")
      merge_voyage_no = [capitalize_name, "_", self.voyage_no, self.voyage_leg].join("")
      [merge_voyage_no, self.vessel.name]
    end

    def apply_port_dept
      read_attribute('apply_port_dept') || manual_port_dept || port_dept
    end

    def apply_port_arrival
      read_attribute('apply_port_arrival') || manual_port_arrival || port_arrival
    end

    def apply_atd_lt
      read_attribute('apply_atd_lt') || manual_atd_lt || atd_lt
    end

    def apply_ata_lt
      read_attribute('apply_ata_lt') || manual_ata_lt || ata_lt
    end

    def apply_atd_utc
      read_attribute('apply_atd_utc') || manual_atd_utc || atd_utc
    end

    def apply_ata_utc
      read_attribute('apply_ata_utc') || manual_ata_utc || ata_utc
    end

    def apply_distance
      read_attribute('apply_distance') || manual_distance || distance
    end

    def apply_duration
      read_attribute('apply_duration') || manual_duration || duration
    end

    def apply_average_speed
      read_attribute('apply_average_speed') || manual_average_speed || average_speed
    end
  end
end
