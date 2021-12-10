module Analytic
  module V1
    module Management
      class MasterPortSerializer
        include FastJsonapi::ObjectSerializer
        attributes :id, :name, :country, :updated_at, :country_code
        attribute :updated_by do |object|
          object.fullname
        end

        attribute :time_zone_name do |object|
          zone = ActiveSupport::TimeZone[object.time_zone] rescue nil
          "#{zone&.name} (UTC #{zone&.formatted_offset})"
        end

        attribute :time_zone_code do |object|
          object.time_zone
        end

        attribute :country do |object|
          TZInfo::Country.get(object.country_code).name rescue nil
        end
      end
    end
  end
end
