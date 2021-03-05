module Analytic
  module V1
    module Vessels
      class StageSpecsController < BaseController
        def index
          specs = Analytic::VesselServices::StageSpecs.new(params[:imo], params[:time]).call
          specs_json = Analytic::V1::Vessels::StageSpecsSerializer.new(specs).serializable_hash
          json_response(specs_json)
        end

        def spec_params
          params.permit(:time, :imo)
        end
      end
    end
  end
end
