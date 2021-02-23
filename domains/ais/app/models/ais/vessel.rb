module Ais
  class Vessel < ApplicationRecord
    self.table_name = "vessels"

    extend Enumerize

    enumerize :engine_type, in: [:stage, :xdf]

    validates :imo, presence: true,  uniqueness: true

    scope :target, -> (target) { where(target: target) if target.present? }
    scope :imo, -> (imo) { where(imo: imo) if imo.present? }
    scope :engine_type, -> (engine_type) { where(engine_type: engine_type) if engine_type.present? }
  end
end
