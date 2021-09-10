module Analytic
  module SimServices
    module Importing
      class SimChannel
        DATA_CLASS = 'IoSData'.freeze
        DATA_TYPE = 'ShipData'.freeze

        def initialize(
          imo:, 
          sim_metadata_requester: ExternalServices::Shipdc::MetaData,
          sim_metadata_find_requester: ExternalServices::Shipdc::MetaDataFind
        )
          @imo = imo
          @sim_metadata_requester = sim_metadata_requester
          @sim_metadata_find_requester = sim_metadata_find_requester
          @columns_mapping = {}
        end

        def call
          Analytic::SimChannel.collection.insert_many(processing_records)
          reindex
          Rails.cache.delete(:channel_units)
          self.fetch_units
        end

        private
        def processing_records
          [].tap do |records|
            metadata.each do |row|
              unit = row[:unit].to_s.strip
              unit = [nil, "", "-"].include?(unit) ? "N/A" : unit
              records << {
                standard_name: row[:isoStdName].parameterize(separator: '_').to_sym,
                iso_std_name: row[:isoStdName],
                local_name: row[:localName],
                unit: unit,
                imo_no: @imo
              }
            end
          end
        end

        def latest_meta_data_revno
          @latest_meta_data_revno ||= begin
            body = @sim_metadata_requester.new(@imo).fetch
            body[:metadata].select { |meta| meta[:dataClass] == DATA_CLASS && meta[:dataType] == DATA_TYPE }
                           .sort_by { |meta| meta[:revNo].to_i }
                           .last
          end
        end

        def metadata
          @metadata ||= begin
            body = @sim_metadata_find_requester.new(@imo, { 
              dataClass: DATA_CLASS, 
              dataType: DATA_TYPE, 
              revNo: latest_meta_data_revno[:revNo] 
            }).fetch
            body[:items]
          end
        end

        def reindex
          Mongoid::Search.classes.each do |klass|
            klass.index_keywords!
          end
        end
      end
    end
  end
end
