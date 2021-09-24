module Analytic
  module V1
    module Vessels
      class StageSpecsControllerInvalidParameters < ActionController::BadRequest; end
      class StageSpecsController < BaseController
        before_action :validate_params, only: [:index]

        def index
          vessel = Analytic::Vessel.find_by(imo: spec_params[:imo])
          from_time = spec_params[:from_time].presence || vessel.last_port_departure_at
          to_time = spec_params[:to_time].presence || Time.current.utc
          specs = Analytic::VesselServices::StageSpecs.new(params[:imo], params[:time], from_time, to_time).call
          specs_json = Analytic::V1::Vessels::StageSpecsSerializer.new(specs).serializable_hash
          json_response(specs_json)
        end

        private
        def spec_params
          params.permit(:time, :from_time, :to_time, :imo)
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
