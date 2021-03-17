module Ais
  class Vessel < ApplicationRecord
    self.table_name = "vessels"

    extend Enumerize

    enumerize :engine_type, in: [:stage, :xdf]

    validates :imo, presence: true, uniqueness: true
    validates :ecdis_email, presence: true, email: true,
              uniqueness: { case_sensitive: true }, if: -> { target.present? }

    scope :imo, -> (imo) { where(imo: imo) if imo.present? }
    scope :target, -> (target) { where(target: target) if target.present? }
    scope :engine_type, -> (engine_type) { where(engine_type: engine_type) if engine_type.present? }
    scope :ecdis_email, -> (ecdis_email) { where(ecdis_email: ecdis_email) if ecdis_email.present? }

    has_many :ecdis_routes, class_name: :EcdisRoute, foreign_key: :imo, primary_key: :imo
  end
end
