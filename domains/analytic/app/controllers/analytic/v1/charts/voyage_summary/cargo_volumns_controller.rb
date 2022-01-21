module Analytic
  module V1
    module Charts
      module VoyageSummary
        class CargoVolumnsController < BaseController
          def index
            charts = Analytic::ChartServices::VoyageSummary::SingleFieldChart.new(
              imo: params[:imo].to_i,
              voyage_no: params[:voyage_no].slice(0, 3),
              voyage_leg: params[:voyage_no].last,
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
