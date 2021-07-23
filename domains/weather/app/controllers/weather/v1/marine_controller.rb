module Weather
  module V1
    class MarineController < BaseController
      def index
        response = Weather::MarineWeatherServices::Element.new(
          element: ocean_current_params[:element],
          date: ocean_current_params[:date],
          bounds: ocean_current_params[:bounds],
          zoom: ocean_current_params[:zoom],
        ).()
        json_response(response)
      end

      private

      def ocean_current_params
        params.permit(:element, :date, :zoom, bounds: {})
      end
    end
  end
end
