module Ais
  module V1
    class LatestPositionsController < BaseController
      VESSEL_PER_PAGE = 100

      def index
        page_number = (params[:page] || 1).to_i
        pagy, vessels = pagy_countless(Vessel.all, items: VESSEL_PER_PAGE)
        latest_position = ExternalServices::Csm::LatestPosition.new({
          imos: vessels.pluck(:imo)
        }).fetch

        vessels_hashing = vessels.index_by(&:imo)
        latest_position_data = latest_position[:data]
          .reject {|record| record[:attributes][:error].present? }
          .map do |record|
            Ais::LatestPosition.new(record[:attributes]).tap do |position| 
              position.vessel_instance = vessels_hashing[record[:attributes][:imo].to_i]
            end
          end
        latest_position_json = Ais::V1::Vessels::LatestPositionSerializer.new(latest_position_data).serializable_hash

        pagy_headers_merge(pagy)
        json_response(latest_position_json)
      end
    end
  end
end
