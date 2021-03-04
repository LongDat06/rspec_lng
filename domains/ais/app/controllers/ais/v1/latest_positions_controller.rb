module Ais
  module V1
    class LatestPositionsController < BaseController
      VESSEL_PER_PAGE = 100

      def index
        page_number = (params[:page] || 1).to_i
        pagy, vessels_imo = pagy_countless(Vessel.all, items: VESSEL_PER_PAGE)
        latest_position = ExternalServices::Csm::LatestPosition.new({
          imos: vessels_imo.pluck(:imo)
        }).fetch
        latest_position_json = Ais::V1::Vessels::LatestPositionSerializer.new(
          latest_position[:data]
            .reject {|record| record[:attributes][:error].present? }
            .map {|record| Ais::LatestPosition.new(record[:attributes]) }
        ).serializable_hash

        pagy_headers_merge(pagy)
        json_response(latest_position_json)
      end
    end
  end
end
