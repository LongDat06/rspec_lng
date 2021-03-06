module Ais
  class VesselDestination < ApplicationRecord
    self.table_name = "vessel_destinations"

    extend Enumerize

    enumerize :source, in: [:spire, :spas, :sim]

    scope :imo, ->(imo) { where(imo: imo) if imo.present? }

    scope :closest_time, -> (time, imo) {
      where(imo: imo).
      where('last_ais_updated_at >= ? OR last_ais_updated_at <= ?', time, time).
      order(Arel.sql("abs(extract(epoch from last_ais_updated_at::timestamp - '#{time}'::timestamp))"))
    }

    belongs_to :vessel, class_name: :Vessel, foreign_key: :imo, primary_key: :imo

    attr_accessor :tracking
  end
end
