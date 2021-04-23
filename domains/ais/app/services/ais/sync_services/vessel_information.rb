module Ais
  module SyncServices
    class VesselInformation
      def call
        sync_vessel
      end

      private
      def sync_vessel
        Vessel.find_in_batches(batch_size: 20) do |vessels|
          vessels_hashing = vessels.index_by(&:imo)
          vessel_info = get_vessel_info(vessels.pluck(:imo))
          latest_position_data = deserialize_vessel_info(vessel_info[:data])
          import_vessel(latest_position_data)
        end
      end

      def import_vessel(vessels)
        Ais::Vessel.import!(
          vessels, on_duplicate_key_update: {conflict_target: [:imo], columns: [:name]}
        )
      end

      def get_vessel_info(imos)
        ExternalServices::Csm::LatestPosition.new({
          imos: imos.uniq
        }).fetch
      end

      def deserialize_vessel_info(data)
        data.reject { |record| record[:attributes][:error].present? }
          .map do |record| 
            { 
              imo:  record[:attributes][:imo], 
              name: record[:attributes][:vessel_name]
            }
          end
      end
    end
  end
end
