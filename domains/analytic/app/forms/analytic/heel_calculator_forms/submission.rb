module Analytic
  module HeelCalculatorForms
    class Validation < StandardError; end
    class Submission
      include ActiveModel::Validations
      include Virtus.model

      attribute :imo,           Integer
      attribute :port_dept,     String
      attribute :port_arrival,  String
      attribute :pacific_route, String
      attribute :etd,           DateTime
      attribute :eta,           DateTime
      attribute :foe,           Float
      attribute :voyage_type,   String


      validates_presence_of :imo, :port_dept, :port_arrival, :pacific_route, :etd, :eta
      validates :foe, numericality: { other_than: 0 }, presence: true
      validates :voyage_type, inclusion: { in: %w(ballast laden) }, presence: true

      validate :eta_after_etd

      def call
        if valid?
          Analytic::HeelServices::Calculator.new(self).()
        else
          raise(Validation, errors.full_messages.join(', '))
        end
      end

      private
      def eta_after_etd
        return if etd.blank? || eta.blank?

        if eta.to_datetime <= etd.to_datetime || ((eta.to_f - etd.to_f)/1.hour).hours < 0.5.hour
          errors.add(:base, I18n.t('analytic.eta_after_etd_at_least_30_mins'))
        end
      end
    end
  end
end
