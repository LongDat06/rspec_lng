module Analytic
  module EdqResultForms
    class Validation < StandardError; end
    class Base
      include ActiveModel::Validations
      include Virtus.model

      attribute :imo,                            Integer
      attribute :name,                           String
      attribute :foe,                            Float
      attribute :init_lng_volume,                Float
      attribute :unpumpable,                     Float
      attribute :cosuming_lng_of_laden_voyage,   Float
      attribute :heel,                           Float
      attribute :edq,                            Float
      attribute :laden_voyage_no,                String
      attribute :ballast_voyage_no,              String
      attribute :laden_voyage,                   HeelResult
      attribute :ballast_voyage,                 HeelResult
      attribute :author_id,                      Integer
      attribute :updated_by_id,                  Integer

      validates_presence_of :imo
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

      validates :laden_voyage, presence: true, if: -> { edq_present? || ballast_voyage.blank? }
      validates :ballast_voyage, presence: true, if: -> { edq_present? || laden_voyage.blank? }
      validate :heels_result_validate

      private
        def heels_result_validate
          errors.add(:laden_voyage, laden_voyage.errors.full_messages.join(', ')) if laden_voyage.present? && !laden_voyage.valid?
          errors.add(:ballast_voyage, ballast_voyage.errors.full_messages.join(', ')) if ballast_voyage.present? && !ballast_voyage.valid?
        end

        def edq_present?
          init_lng_volume.present? ||
          unpumpable.present? ||
          cosuming_lng_of_laden_voyage.present? ||
          heel.present? ||
          edq.present?
        end
    end
  end
end
