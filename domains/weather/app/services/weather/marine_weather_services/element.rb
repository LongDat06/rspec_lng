module Weather
  module MarineWeatherServices
    class Element < Base
      def call
        weather_data
      end

      private
      def weather_data
        @weather_requester.new(build_parameters).fetch
      end

      def build_parameters
        {
          types: @element,
          date: @date.to_i,
          timestep: @timestep,
          zoom: @zoom,
          bounds: @bounds
        }
      end
    end
  end
end
