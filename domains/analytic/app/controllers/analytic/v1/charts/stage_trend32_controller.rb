module Analytic
  module V1
    module Charts
      class StageTrend32Controller < BaseController
        def index
          charts = Analytic::ChartServices::StageTrend32.new(
            chart_params[:from_time], 
            chart_params[:to_time], 
            chart_params[:imo]
          ).()
          json_charts = Analytic::V1::Charts::StageTrend32Serializer.new(charts).serializable_hash
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
