module Analytic
  module V1
    module Vessels
      class XdfSpecsControllerInvalidParameters < ActionController::BadRequest; end
      class XdfSpecsController < BaseController
        before_action :validate_params, only: [:index]

        def index
          specs = Analytic::VesselServices::XdfSpecs.new(params[:imo], params[:time]).call
          specs_json = Analytic::V1::Vessels::XdfSpecsSerializer.new(specs).serializable_hash
          json_response(specs_json)
        end

        private
        def spec_params
          params.permit(:time, :imo)
        end

        def validate_params
          spec_params_validation = Analytic::Validations::Vessels::XdfSpecs.new(spec_params)
          unless spec_params_validation.valid?
            raise(
              XdfSpecsControllerInvalidParameters, 
              spec_params_validation.errors.full_messages.to_sentence
            )
          end
        end
      end
    end
  end
end
