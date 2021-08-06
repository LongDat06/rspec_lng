module Ais
  module SyncServices
    class VesselInformation
      def initialize(imos = [])
        @imos = imos
      end

      def call
        sync_vessel
      end

      private
      def sync_vessel
        vessels_in_scope.find_in_batches(batch_size: 20) do |vessels|
          vessel_info = get_vessel_info(vessels.pluck(:imo))
          latest_position_data = deserialize_vessel_info(vessel_info[:data])
          import_vessel(latest_position_data)
        end
      end

      def vessels_in_scope
        @imos.present? ? Vessel.where(imo: @imos) : Vessel.all
      end

      def import_vessel(vessels)
        Ais::Vessel.import!(
          vessels, on_duplicate_key_update: {conflict_target: [:imo], columns: [:name, :error_code]}
        )
      end

      def get_vessel_info(imos)
        ExternalServices::Csm::LatestPosition.new({
          imos: imos.uniq
        }).fetch
      end

      def deserialize_vessel_info(data)
        data.map do |record| 
          { 
            imo:  record[:attributes][:imo], 
            name: record[:attributes][:vessel_name].presence || "",
            error_code: mapping_error_message(record[:attributes].dig(:error).dig(:message))
          }
        end
      end

      def mapping_error_message(error_message)
        return "" if error_message.blank?
        error_message.parameterize(separator: '_')
      end
    end
  end
end
