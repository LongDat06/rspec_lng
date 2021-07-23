module Weather
  module MarineWeatherServices
    class Base
      def initialize(
        element:,
        date:,
        bounds:,
        zoom: 1,
        timestep: 0,
        weather_requester: Weather::ExternalServices::Csm::MarineWeather
      )
        @element = element
        @date = date
        @bounds = bounds
        @zoom = zoom
        @timestep = timestep
        @weather_requester = weather_requester
      end
    end
  end
end
