module Weather
  module ExternalServices
    module Csm
      class MarineWeather < Base
        URI = '/v1/weather_forecasts/weathers'.freeze

        def initialize(params)
          super()
          @params = params
        end

        def fetch
          @response = self.class.get("#{URI}", options)
          super
        end

        def body
          {
            timeout: 300,
            verify: false,
            query: @params
          }
        end
      end
    end
  end
end
