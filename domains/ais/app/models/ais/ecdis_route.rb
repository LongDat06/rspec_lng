module Ais
  class EcdisRoute < ApplicationRecord
    self.table_name = "ecdis_routes"

    extend Enumerize

    enumerize :format_file, in: [:furuno, :jrc]

    scope :imo, ->(imo) { where(imo: imo) if imo.present? }
    scope :of_month, ->(time) {
      where("received_at <= ? AND received_at >= ?", time, time - 1.month) if time.present?
    }

    belongs_to :vessel, class_name: :Vessel, foreign_key: :imo, primary_key: :imo
    has_many :ecdis_points, ->() { order(id: :asc) }
  end
end
