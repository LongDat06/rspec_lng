module Ais
  module V1
    module Vessels
      class InfoController < BaseController
        def index
          authorize Ais::Vessel, policy_class: Ais::Vessels::InfoPolicy
          vessel = Ais::Vessel.find_by!(imo: params[:imo])
          vessel_json = Ais::V1::Vessels::InfoSerializer.new(vessel).serializable_hash
          json_response(vessel_json)
        end
      end
    end
  end
end
