module Analytic
  module SpasServices
    module Importing
      class SpasData
        BATCH_IMPORT_SIZE = 1
        DATA_CLASS = 'RepData'.freeze
        DATA_TYPE = 'AtSeaReport'.freeze

        def initialize(
          imo_no:, 
          period_time:,
          rep_data_requester: ExternalServices::Shipdc::RepData
        )
          @imo_no = imo_no
          @period_time = period_time
          @rep_data_requester = rep_data_requester
          @records = []
        end

        def call
          processing_rows
        end

        private
        attr_reader :records

        def getting_meta_data(revno)
          @meta ||= {}
          @meta[revno] ||= begin
            Analytic::SpasServices::Importing::SpasMetadata.new(
              imo_no: @imo_no,
              revno: revno,
            ).()
          end
        end

        def processing_rows
          rep_data.each do |row|
            row[:series].each do |serie|
              meta_data = getting_meta_data(serie[:revNo])
              spec = serie[:items].map do |item|
                [item[:idx], item[:value]]
              end.to_h
              records << modeling_record(spec, meta_data)
            end
          end

          opts = import_records
          opts.inserted_ids
        end

        def import_records
          Analytic::Spas.collection.insert_many(records)  
        end

        def modeling_spas_spec(spec, columns_mapping)
          {}.tap do |hashing|
            columns_mapping.each do |column_name, column_mapped|
              next if spec.blank?
              row_data = spec[column_mapped[:index]]
              hashing[column_name] = if numeric?(row_data)
                row_data.to_f
              elsif datetime?(row_data)
                row_data.to_datetime
              else
                row_data.present? ? row_data.strip : row_data
              end
            end
          end
        end

        def modeling_record(spec, meta_data)
          {
            imo_no: @imo_no,
            spas_metadata_id: meta_data.spas_meta_data.id,
            created_at: Time.current,
            spec: modeling_spas_spec(spec, meta_data.columns_mapping)
          }
        end

        def numeric?(data)
          data.numeric?
        end

        def datetime?(data)
          data.to_datetime.class == DateTime
        rescue StandardError
          false
        end

        def rep_data
          @rep_data ||= begin
            body = @rep_data_requester.new(@imo_no, {
              dataType: DATA_TYPE,
              from: @period_time.beginning_of_day.strftime('%FT%TZ'),
              to: @period_time.end_of_day.strftime('%FT%TZ')
            }).fetch
            body[:data]
          end
        end
      end
    end
  end
end
