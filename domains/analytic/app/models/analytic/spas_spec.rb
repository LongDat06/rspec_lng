module Analytic
  class SpasSpec
    include Mongoid::Document

    embedded_in :spas
  end
end
