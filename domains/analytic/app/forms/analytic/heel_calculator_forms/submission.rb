module Analytic
  module HeelCalculatorForms
    class Validation < StandardError; end
    class Submission
      include ActiveModel::Validations
      include Virtus.model

      attribute :imo,             Integer
      attribute :port_dept_id,    Integer
      attribute :port_arrival_id, Integer
      attribute :master_route_id, Integer
      attribute :etd,             Time
      attribute :eta,             Time
      attribute :foe,             Float
      attribute :sea_margin,      Float
      attribute :voyage_type,     String


      validates_presence_of :imo, :port_dept_id, :port_arrival_id, :master_route_id, :etd , :eta
      validates :foe, numericality: { other_than: 0 }, presence: true
      validates :sea_margin, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, presence: true
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
