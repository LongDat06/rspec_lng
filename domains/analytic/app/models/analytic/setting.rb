module Analytic
  class Setting < ApplicationRecord

    LNG_CONSUMPTION_IN_PANAMA_CODE = 'LNG_CONSUMPTION_IN_PANAMA'

    validates :code, presence: true, uniqueness: true

  end
end
