module Analytic
  class Vessel < ApplicationRecord
    self.table_name = "vessels"

    scope :target, -> (target) { where(target: target) if target.present? }
    
    def readonly?
      true
     end
  end
end
