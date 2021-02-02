module Analytic
  module V1
    module Charts
      class XdfBoilOffRateController < BaseController
        def index
          charts = Analytic::ChartServices::XdfBoilOffRate.new(
            chart_params[:from_time], 
            chart_params[:to_time], 
            chart_params[:imo]
          ).()
          json_charts = Analytic::V1::Charts::XdfBoilOffRateSerializer.new(charts).serializable_hash
          json_response(json_charts)
        end

        private

        def chart_params
          params.permit(:from_time, :to_time, :imo)
        end
      end
    end
  end
end
