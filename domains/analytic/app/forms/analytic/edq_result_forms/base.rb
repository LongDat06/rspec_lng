module Analytic
  module EdqResultForms
    class Validation < StandardError; end
    class Base
      include ActiveModel::Validations
      include Virtus.model

      attribute :imo,                                 Integer
      attribute :name,                                String
      attribute :foe,                                 Float
      attribute :init_lng_volume,                     Float
      attribute :unpumpable,                          Float
      attribute :cosuming_lng_of_laden_voyage,        Float
      attribute :cosuming_lng_of_ballast_voyage,      Float
      attribute :edq,                                 Float
      attribute :cosuming_lng_of_laden_voyage_leg1,   Float
      attribute :cosuming_lng_of_laden_voyage_leg2,   Float
      attribute :cosuming_lng_of_ballast_voyage_leg1, Float
      attribute :cosuming_lng_of_ballast_voyage_leg2, Float
      attribute :laden_pa_transit,                    Boolean
      attribute :ballast_pa_transit,                  Boolean
      attribute :laden_voyage_no,                     String
      attribute :ballast_voyage_no,                   String
      attribute :laden_voyage_leg1,                   HeelResult
      attribute :ballast_voyage_leg1,                 HeelResult
      attribute :laden_voyage_leg2,                   HeelResult
      attribute :ballast_voyage_leg2,                 HeelResult
      attribute :landen_fuel_consumption_in_pa,       Float
      attribute :ballast_fuel_consumption_in_pa,      Float
      attribute :estimated_heel_leg1,                 Float
      attribute :estimated_heel_leg2,                 Float
      attribute :author_id,                           Integer
      attribute :updated_by_id,                       Integer

      validates_presence_of :imo
      validates_inclusion_of :laden_pa_transit, in: [true, false]
      validates_inclusion_of :ballast_pa_transit, in: [true, false]
      validates :foe, numericality: { other_than: 0 }, presence: true


      validates :laden_voyage_no, presence: true,
                                  format: { with: /\A\d{3}\z/,
                                  message: I18n.t('analytic.voyage_no_invalid_format') }
      validates :ballast_voyage_no, presence: true,
                                    format: { with: /\A\d{3}\z/,
                                    message: I18n.t('analytic.voyage_no_invalid_format') }
      validates_presence_of :edq,
                            :init_lng_volume,
                            :unpumpable,
                            :cosuming_lng_of_laden_voyage, if: :edq_present?

      validates :laden_voyage_leg1, presence: true, if: -> { edq_present? || ballast_voyage_leg1.blank? || laden_voyage_leg2.present? }
      validates :ballast_voyage_leg1, presence: true, if: -> { edq_present? || laden_voyage_leg1.blank? || ballast_voyage_leg2.present? }
      validates :laden_voyage_leg2, presence: true, if: -> { laden_pa_transit  }
      validates :ballast_voyage_leg2, presence: true, if: -> { ballast_pa_transit }
      validate :heels_result_validate

      private
        def heels_result_validate
          errors.add(:laden_voyage_leg1, laden_voyage_leg1.errors.full_messages.join(', ')) if laden_voyage_leg1.present? && !laden_voyage_leg1.valid?
          errors.add(:ballast_voyage_leg1, ballast_voyage_leg1.errors.full_messages.join(', ')) if ballast_voyage_leg1.present? && !ballast_voyage_leg1.valid?
          errors.add(:laden_voyage_leg2, laden_voyage_leg2.errors.full_messages.join(', ')) if laden_voyage_leg2.present? && !laden_voyage_leg2.valid?
          errors.add(:ballast_voyage_leg2, ballast_voyage_leg2.errors.full_messages.join(', ')) if ballast_voyage_leg2.present? && !ballast_voyage_leg2.valid?
        end

        def edq_present?
          init_lng_volume.present? ||
          unpumpable.present? ||
          edq.present?
        end
    end
  end
end
