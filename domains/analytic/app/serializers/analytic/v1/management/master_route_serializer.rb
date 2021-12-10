module Analytic
  module V1
    module Management
      class MasterRouteSerializer
        include FastJsonapi::ObjectSerializer
        attributes :id, :name
      end
    end
  end
end
