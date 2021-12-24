module Analytic
  module V1
    module Charts
      class PowerCurveController < BaseController
        def index
          charts = Analytic::ChartServices::PowerCurve.new(
            voyage_summary_id: chart_params[:voyage_summary_id],
            margin_drop: chart_params[:margin_drop]
          ).call
          json_charts = Analytic::V1::Charts::PowerCurveSerializer.new(charts).serializable_hash
          json_response(json_charts)
        end

        private

        def chart_params
          params.permit(:voyage_summary_id, :margin_drop)
        end
      end
    end
  end
end
