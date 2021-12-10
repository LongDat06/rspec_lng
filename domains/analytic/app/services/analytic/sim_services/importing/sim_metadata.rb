module Analytic
  module SimServices
    module Importing
      class SimMetadata
        DATA_CLASS = 'IoSData'.freeze
        #DATA_TYPE = 'ShipData'.freeze

        attr_reader :columns_mapping, :sim_meta_data

        def initialize(
          imo_no:,
          data_type:, 
          revno:,
          sim_metadata_find_requester: ExternalServices::Shipdc::MetaDataFind
        )
          @imo = imo_no
          @data_type = data_type
          @revno = revno
          @sim_metadata_find_requester = sim_metadata_find_requester
          @columns_mapping = {}
        end

        def call
          mapped_columns
          @sim_meta_data = Analytic::SimMetadata.new(
            imo_no: @imo, 
            dataclass: DATA_CLASS, 
            datatype: @data_type, 
            revisionno: @revno,
            created_at: Time.current.utc
          )
          @sim_meta_data.save!
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
              dataType: @data_type, 
              revNo: @revno
            }).fetch
            body[:items]
          end
        end
      end
    end
  end
end
