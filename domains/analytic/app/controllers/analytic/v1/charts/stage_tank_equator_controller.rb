module Analytic
  module V1
    module Charts
      class StageTankEquatorController < BaseController
        def index
          charts = Analytic::ChartServices::StageTankEquator.new(
            chart_params[:from_time], 
            chart_params[:to_time], 
            chart_params[:imo]
          ).()
          json_charts = Analytic::V1::Charts::StageTankEquatorSerializer.new(charts).serializable_hash
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
