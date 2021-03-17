module Ais
  class EcdisPoint < ApplicationRecord
    self.table_name = "ecdis_points"

    extend Enumerize
    enumerize :leg_type, in: [:RL, :GC]

    belongs_to :ecdis_route
  end
end
