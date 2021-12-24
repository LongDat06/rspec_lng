module Ais
  module V1
    class LatestPositionsController < BaseController
      VESSEL_PER_PAGE = 100

      def index
        relation = Vessel.all
        relation = relation.where(imo: params[:imo]) if params[:imo].present?
        pagy, vessels = pagy_countless(relation, items: VESSEL_PER_PAGE)
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
