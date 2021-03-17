module Ais
  class EcdisRoute < ApplicationRecord
    self.table_name = "ecdis_routes"

    extend Enumerize

    enumerize :format_file, in: [:furuno, :jrc]

    belongs_to :vessel, class_name: :Vessel, foreign_key: :imo, primary_key: :imo
    has_many :ecdis_points
  end
end
