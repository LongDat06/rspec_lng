module Analytic
  module V1
    module Management
      class FocSerializer
        include FastJsonapi::ObjectSerializer
        attributes :id, :imo, :speed, :laden, :ballast, :updated_at, :vessel_name

        attribute :updated_by do |object|
          object.fullname
        end
      end
    end
  end
end
