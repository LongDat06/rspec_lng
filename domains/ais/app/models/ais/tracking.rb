module Ais
  class Tracking < ApplicationRecord
    self.table_name = "trackings"

    extend Enumerize

    enumerize :source, in: [:spire, :sim]

    scope :imo, ->(imo) { where(imo: imo) if imo.present? }

    def self.closest_time(time, imo)
      relation = self.where(imo: imo)
      first_larger = relation.where('last_ais_updated_at >= ?', time).order(:last_ais_updated_at).first
      first_smaller = relation.where('last_ais_updated_at <= ?', time).order(last_ais_updated_at: :desc).first
      time_parser = Time.find_zone("UTC").parse(time.to_s).utc
      [first_larger,first_smaller].compact.min_by { |ais| (ais.last_ais_updated_at - time_parser).abs }
    end

    belongs_to :vessel, class_name: :Vessel, foreign_key: :imo, primary_key: :imo
  end
end
