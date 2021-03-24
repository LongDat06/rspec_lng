module Analytic
  module SpasServices
    module Importing
      class SpasMetadata
        DATA_CLASS = 'RepData'.freeze
        DATA_TYPE = 'AtSeaReport'.freeze

        attr_reader :columns_mapping, :spas_meta_data

        def initialize(
          imo_no:, 
          revno:,
          sim_metadata_find_requester: ExternalServices::Shipdc::MetaDataFind
        )
          @imo = imo_no
          @revno = revno
          @sim_metadata_find_requester = sim_metadata_find_requester
          @columns_mapping = {}
        end

        def call
          mapped_columns
          @spas_meta_data = Analytic::SpasMetadata.new(
            imo_no: @imo, 
            dataclass: DATA_CLASS, 
            datatype: DATA_TYPE, 
            revisionno: @revno,
            created_at: Time.current.utc
          )
          @spas_meta_data.save!
          self
        end

        private
        def mapped_columns
          metadata.each do |row|
            next if row.blank?
            column_name = row[:isoStdName].parameterize(separator: '_').to_sym
            columns_mapping[column_name] = {
              index: row[:idx]
            }
          end
        end

        def metadata
          @metadata ||= begin
            body = @sim_metadata_find_requester.new(@imo, { 
              dataClass: DATA_CLASS, 
              dataType: DATA_TYPE, 
              revNo: @revno
            }).fetch
            body[:items]
          end
        end
      end
    end
  end
end
