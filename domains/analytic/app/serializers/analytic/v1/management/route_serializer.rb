module Analytic
  module V1
    module Management
      class RouteSerializer
        include FastJsonapi::ObjectSerializer
        attributes :id, :port_1_name, :port_2_name, :route_name, :distance, :detail, :updated_at

        attribute :updated_by do |object|
          object.fullname
        end
      end
    end
  end
end

