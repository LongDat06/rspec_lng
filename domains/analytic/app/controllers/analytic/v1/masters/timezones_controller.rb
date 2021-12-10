module Analytic
  module V1
    module Masters
      class TimezonesController < BaseController

        def show
          zones = ActiveSupport::TimeZone.country_zones(params[:country_code])
          data = zones.map do |zone|
            { code: zone.name, name: "#{zone.name} (UTC #{zone.formatted_offset})" }
          end
          json_response(data)
        end

      end
    end
  end
end
