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
  end
end
