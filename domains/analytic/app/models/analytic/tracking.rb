module Analytic
  class Tracking < ApplicationRecord
    self.table_name = "trackings"

    extend Enumerize

    enumerize :source, in: [:spire, :sim]

    scope :imo, ->(imo) { where(imo: imo) if imo.present? }
  end
end