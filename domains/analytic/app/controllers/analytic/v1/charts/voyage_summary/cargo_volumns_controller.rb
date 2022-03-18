module Analytic
  module V1
    module Charts
      module VoyageSummary
        class CargoVolumnsController < BaseController
          def index
            charts = Analytic::ChartServices::VoyageSummary::SingleFieldChart.new(
              voyage_id: params[:voyage_id],
              chart_name: Analytic::VoyageSummary::CARGO_VOLUMN_CHART
            ).()

            json_charts = Analytic::V1::Charts::VoyageSummary::CargoVolumnSerializer.new(charts).serializable_hash
            json_response(json_charts)
          end
        end
      end
    end
  end
end
