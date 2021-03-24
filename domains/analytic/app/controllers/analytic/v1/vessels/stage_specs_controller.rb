module Analytic
  module V1
    module Vessels
      class StageSpecsControllerInvalidParameters < ActionController::BadRequest; end
      class StageSpecsController < BaseController
        before_action :validate_params, only: [:index]

        def index
          specs = Analytic::VesselServices::StageSpecs.new(params[:imo], params[:time]).call
          specs_json = Analytic::V1::Vessels::StageSpecsSerializer.new(specs).serializable_hash
          json_response(specs_json)
        end

        private
        def spec_params
          params.permit(:time, :imo)
        end

        def validate_params
          spec_params_validation = Analytic::Validations::Vessels::StageSpecs.new(spec_params)
          unless spec_params_validation.valid?
            raise(
              StageSpecsControllerInvalidParameters, 
              spec_params_validation.errors.full_messages.to_sentence
            )
          end
        end
      end
    end
  end
end
