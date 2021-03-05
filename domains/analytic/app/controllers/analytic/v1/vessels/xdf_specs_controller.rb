module Analytic
  module V1
    module Vessels
      class XdfSpecsController < BaseController
        def index
          specs = Analytic::VesselServices::XdfSpecs.new(params[:imo], params[:time]).call
          specs_json = Analytic::V1::Vessels::XdfSpecsSerializer.new(specs).serializable_hash
          json_response(specs_json)
        end

        def spec_params
          params.permit(:time, :imo)
        end
      end
    end
  end
end
