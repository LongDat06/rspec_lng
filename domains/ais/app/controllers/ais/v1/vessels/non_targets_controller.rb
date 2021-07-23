module Ais
  module V1
    module Vessels
      class NonTargetsController < BaseController
        def create
          authorize Ais::Vessel, policy_class: Ais::Vessels::NonTargetsPolicy
          opts = VesselForms::ImportNonTarget.new(vessel_params[:imos])
          opts.create
          json_response({ invalid_imos: opts.invalid_imos })
        end

        private
        def vessel_params
          params.permit(imos: [])
        end
      end
    end
  end
end
