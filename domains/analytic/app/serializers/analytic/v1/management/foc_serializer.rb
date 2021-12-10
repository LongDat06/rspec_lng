module Analytic
  module V1
    module Management
      class FocSerializer
        include FastJsonapi::ObjectSerializer
        attributes :id, :imo, :speed, :laden, :ballast, :vessel_name, :updated_at

        attribute :updated_by do |object|
          object.fullname
        end
      end
    end
  end
end
