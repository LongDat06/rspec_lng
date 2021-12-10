module Analytic
  module V1
    module Management
      class RouteSerializer
        include FastJsonapi::ObjectSerializer
        attributes :id, :port_1, :port_2, :pacific_route, :distance, :detail, :updated_at

        attribute :updated_by do |object|
          object.fullname
        end
      end
    end
  end
end

