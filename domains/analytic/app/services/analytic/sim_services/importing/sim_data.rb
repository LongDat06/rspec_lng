module Analytic
  module SimServices
    module Importing
      class SimData
        BATCH_IMPORT_SIZE = 1
        DATA_CLASS = 'IoSData'.freeze
        DATA_TYPE = 'ShipData'.freeze

        def initialize(
          imo_no:, 
          period_hour:,
          ios_data_requester: ExternalServices::Shipdc::IosData
        )
          @imo_no = imo_no
          @period_hour = period_hour
          @ios_data_requester = ios_data_requester
          @records = []
          @counter = 0
        end

        def call
          processing_rows
        end

        private
        attr_reader :records
        attr_accessor :counter

        def getting_meta_data(revno)
          @meta ||= {}
          @meta[revno] ||= begin
            Analytic::SimServices::Importing::SimMetadata.new(
              imo_no: @imo_no,
              revno: revno,
            ).()
          end
        end

        def processing_rows
          ios_data.each do |row|
            row[:series].each do |serie|
              increment_counter
              meta_data = getting_meta_data(serie[:revNo])
              spec = serie[:items].map do |item|
                [item[:idx], item[:value]]
              end.to_h
              records << modeling_record(spec, meta_data)
            end
            
            import_records if reached_batch_import_size? || reached_end_of_file?
          end
        end

        def increment_counter
          self.counter += 1
        end

        def import_records
          Analytic::Sim.collection.insert_many(records)  
          records.clear
        end

        def modeling_sim_spec(spec, columns_mapping)
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
            sim_metadata_id: meta_data.sim_meta_data.id,
            created_at: Time.current,
            spec: modeling_sim_spec(spec, meta_data.columns_mapping)
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

        def ios_data
          @ios_data ||= begin
            body = @ios_data_requester.new(@imo_no, {
              dataType: DATA_TYPE,
              from: @period_hour.beginning_of_hour.strftime('%FT%TZ'),
              to: @period_hour.end_of_hour.strftime('%FT%TZ')
            }).fetch
            body[:data]
          end
        end

        def reached_batch_import_size?
          (counter % BATCH_IMPORT_SIZE).zero?
        end

        def row_count
          @row_count ||= ios_data.first[:series].size
        end

        def reached_end_of_file?
          counter == row_count
        end
      end
    end
  end
end
