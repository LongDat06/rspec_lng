module Ais
  module VesselDestinationServices
    module Importing
      class ImportProcessingError < StandardError; end
      class ImportProcessing
        attr_reader :data_existed

        def initialize(
          imo:, 
          from_date:, 
          to_date:, 
          last_id:, 
          vessel_destination_requester: ExternalServices::Csm::VesselDestination
        )
          @imo = imo
          @from_date = from_date
          @to_date = to_date
          @last_id = last_id
          @vessel_destination_requester = vessel_destination_requester
        end

        def call
          @data_existed = vessel_destinations[:data].first.present?
          Ais::VesselDestination.import!(mapping_vessel_destinations)
        end

        private
        def vessel_destinations
          @vessel_destinations ||= @vessel_destination_requester.new(build_parameter).fetch
        end

        def mapping_vessel_destinations
          vessel_destinations[:data].map do |vessel_destination|
            attributes = vessel_destination[:attributes]

            {
              vessel_id: attributes[:vessel_id],
              csm_id: vessel_destination[:id],
              csm_created_at: attributes[:created_at],
              destination: attributes[:destination],
              draught: attributes[:draught],
              eta: attributes[:eta],
              last_ais_updated_at: attributes[:last_ais_updated_at],
              imo: @imo.to_i
            }
          end
        end

        def build_parameter
          {
            imos: [@imo],
            from_time: @from_date,
            to_time: @to_date,
            last_id: @last_id,
          }
        end
      end
    end
  end
end
