module Analytic
  class SimSpec
    include Mongoid::Document

    embedded_in :sim
  end
end
