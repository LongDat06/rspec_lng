module Ais
  module TrackingServices
    module Importing
      class ImportProcessingError < StandardError; end
      class ImportProcessing
        attr_reader :data_existed

        def initialize(
          imo:,
          from_date:,
          to_date:,
          last_id:,
          tracking_requester: ExternalServices::Csm::Tracking
        )
          @imo = imo
          @from_date = from_date
          @to_date = to_date
          @last_id = last_id
          @tracking_requester = tracking_requester
        end

        def call
          @data_existed = trackings[:data].first.present?
          Ais::Tracking.import!(mapping_trackings)
        end

        private
        def trackings
          @trackings ||= @tracking_requester.new(build_parameter).fetch
        end

        def mapping_trackings
          trackings[:data].map do |tracking|
            attributes = tracking[:attributes]

            {
              csm_id: attributes[:id],
              csm_created_at: attributes[:created_at],
              latitude: attributes[:latitude],
              longitude: attributes[:longitude],
              heading: attributes[:heading],
              speed_over_ground: attributes[:speed_over_ground],
              last_ais_updated_at: attributes[:last_ais_updated_at],
              nav_status_code: attributes[:nav_status_code],
              vessel_id: attributes[:vessel_id],
              course: attributes[:course],
              collection_type: attributes[:collection_type].to_s,
              source: attributes[:source],
              is_valid: attributes[:is_valid],
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
