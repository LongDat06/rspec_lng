module Analytic
  module V1
    module Charts
      module VoyageSummary
        class SummariesController < BaseController
          def index
            charts = Analytic::ChartServices::VoyageSummary::SummaryChart.new(
              params[:imo].to_i,
              params[:voyage_no].slice(0, 3),
              params[:voyage_no].last
            ).()

            json_charts = Analytic::V1::Charts::VoyageSummary::SummarySerializer.new(charts).serializable_hash
            json_response(json_charts)
          end
        end
      end
    end
  end
end
