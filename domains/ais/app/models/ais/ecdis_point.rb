module Ais
  class EcdisPoint < ApplicationRecord
    self.table_name = "ecdis_points"

    extend Enumerize
    enumerize :leg_type, in: [:RL, :GC]

    scope :routes, ->(routes) { where(ecdis_route_id: routes) if routes.present? }
    
    belongs_to :ecdis_route
  end
end
