module Analytic
  module V1
    module Charts
      class BlrFlowController < BaseController
        def index
          charts = Analytic::ChartServices::BlrFlow.new(
            chart_params[:from_time],
            chart_params[:to_time],
            chart_params[:imo],
            chart_params[:closest_at],
          ).()
          json_charts = Analytic::V1::Charts::BlrFlowSerializer.new(charts).serializable_hash
          json_response(json_charts)
        end

        private
        def chart_params
          params.permit(:from_time, :to_time, :imo, :closest_at)
        end
      end
    end
  end
end
