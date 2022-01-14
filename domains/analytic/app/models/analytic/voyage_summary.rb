module Analytic
  class VoyageSummary < ApplicationRecord
    belongs_to :edq_results, class_name: Analytic::EdqResult.name, foreign_key: :analytic_edq_results_id, optional: true
    belongs_to :vessel, class_name: :Vessel, foreign_key: :imo, primary_key: :imo

    validates_presence_of :imo, :voyage_no, :voyage_leg
    validates_uniqueness_of :imo, scope: %i[voyage_no voyage_leg]

    scope :dept_ports, -> {
      where.not(port_dept: nil).order(:port_dept).distinct.pluck(:port_dept)
    }

    scope :arrival_ports, -> {
      where.not(port_arrival: nil).order(:port_arrival).distinct.pluck(:port_arrival)
    }

    scope :with_edq_resuls, -> {
      joins_edq_results.select('analytic_voyage_summaries.*,
                                analytic_edq_results.heel as estimated_heel,
                                analytic_edq_results.edq as estimated_edq')
    }

    scope :joins_edq_results, -> {
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
      all_records = self.class.where(imo: self.imo, voyage_leg: self.voyage_leg, port_dept: self.port_dept, port_arrival: self.port_arrival)
      all_records = all_records.where.not(id: self.id).order({ata_utc: :desc, voyage_no: :asc}).limit(number_of_voyage)
      all_records.to_a
    end

    def get_vessel_names
      capitalize_name = self.vessel.name.split(" ").map(&:chr).join("")
      merge_voyage_no = [capitalize_name, "_", self.voyage_no, self.voyage_leg].join("")
      [merge_voyage_no, self.vessel.name]
    end

  end
end
