module Ais
  class Vessel < ApplicationRecord
    self.table_name = "vessels"

    extend Enumerize

    enumerize :ship_type_id, in: { lng_tanker: 0 }
    enumerize :engine_type, in: [:stage, :xdf]
  end
end
