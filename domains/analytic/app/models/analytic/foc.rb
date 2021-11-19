module Analytic
  class Foc < ApplicationRecord
    validates_uniqueness_of :speed, scope: [:imo]
    validates_presence_of :speed, :imo
  end
end
