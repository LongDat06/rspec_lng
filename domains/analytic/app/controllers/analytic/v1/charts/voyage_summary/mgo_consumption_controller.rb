module Analytic
  module V1
    module Charts
      module VoyageSummary
        class MgoConsumptionController < BaseController
          def index
            engine_type = Analytic::Vessel.get_engine_type(params[:imo].to_i)

            service_names = {
              "xdf" => Analytic::VoyageSummary::XDF_MGO_CONSUMPTION_CHART,
              "stage" => Analytic::VoyageSummary::STAGE_MGO_CONSUMPTION_CHART
            }

            serializer_types = {
              "xdf" => Analytic::V1::Charts::VoyageSummary::XdfMgoConsumptionSerializer,
              "stage" => Analytic::V1::Charts::VoyageSummary::StageMgoConsumptionSerializer
            }

            charts = Analytic::ChartServices::VoyageSummary::SingleFieldChart.new(
              voyage_id: params[:voyage_id],
              chart_name: service_names[engine_type],
              is_positive_number: true
            ).()

            json_charts = serializer_types[engine_type].new(charts).serializable_hash
            json_response(json_charts)
          end
        end
      end
    end
  end
end
