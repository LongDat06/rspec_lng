module Analytic
  module VoyageSummaryForms
    class Validation < StandardError; end

    class UpdateManualFields
      include ActiveModel::Validations
      include Virtus.model

      attribute :id,                   Integer
      attribute :manual_port_dept,     String
      attribute :manual_port_arrival,  String
      attribute :manual_atd_lt,        DateTime
      attribute :manual_ata_lt,        DateTime
      attribute :manual_ata_time_zone, String
      attribute :manual_atd_time_zone, String
      attribute :manual_distance,      Integer

      validates_presence_of :id
      validates :manual_port_dept, :manual_atd_lt, :manual_atd_time_zone, presence: true,
                                                                          if: :manual_port_dept_input?
      validates :manual_port_arrival, :manual_ata_lt, :manual_ata_time_zone, presence: true,
                                                                             if: :manual_port_arrival_input?

      validate :ata_after_atd

      def call
        raise Validation, errors.full_messages.join(', ') unless valid?

        update_voyage_summary
        Analytic::VoyageSummaryServices::Importing::ImportProcessing.new(imo: voyage_summary.imo,
                                                                         voyage_no: voyage_summary.voyage_no,
                                                                         voyage_leg: voyage_summary.voyage_leg).call
      end

      private

      def update_voyage_summary
        voyage_summary.manual_port_dept = manual_port_dept
        voyage_summary.manual_port_arrival = manual_port_arrival
        voyage_summary.manual_atd_lt = manual_atd_lt
        voyage_summary.manual_ata_lt = manual_ata_lt
        voyage_summary.manual_ata_time_zone = manual_ata_time_zone
        voyage_summary.manual_atd_time_zone = manual_atd_time_zone
        voyage_summary.manual_distance = manual_distance
        voyage_summary.manual_atd_utc = manual_atd_utc
        voyage_summary.manual_ata_utc = manual_ata_utc
        voyage_summary.save!
      end

      def manual_atd_utc
        @manual_atd_utc ||= Analytic::HeelServices::TimezoneLabel.new(time: manual_atd_lt,
                                                                      time_zone: manual_atd_time_zone)
                                                                 .call.time_utc
      end

      def manual_ata_utc
        @manual_ata_utc ||= Analytic::HeelServices::TimezoneLabel.new(time: manual_ata_lt,
                                                                      time_zone: manual_ata_time_zone)
                                                                 .call.time_utc
      end

      def voyage_summary
        @voyage_summary ||= Analytic::VoyageSummary.find(id)
      end

      def ata_after_atd
        return if manual_atd_utc.blank? && manual_ata_utc.blank?

        atd = manual_atd_utc || voyage_summary.atd_utc
        ata = manual_ata_utc || voyage_summary.ata_utc

        return if atd.blank? || ata.blank?

        if ata.to_datetime <= atd.to_datetime || ((ata.to_f - atd.to_f) / 1.hour).hours < 0.5.hour
          errors.add(:base, I18n.t('analytic.ata_after_atd_at_least_30_mins'))
        end
      end

      def manual_port_dept_input?
        manual_port_dept.present? || manual_atd_lt.present?
      end

      def manual_port_arrival_input?
        manual_port_arrival.present? || manual_ata_lt.present?
      end
    end
  end
end
