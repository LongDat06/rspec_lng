module Ais
  class Vessel < ApplicationRecord
    self.table_name = "vessels"

    extend Enumerize

    enumerize :ship_type_id, in: { lng_tanker: 0 }
  end
end
