module Analytic
  module SimServices
    module Importing
      class SimData
        DATA_CLASS = 'IoSData'.freeze
        #DATA_TYPE = 'ShipData'.freeze

        def initialize(
          imo_no:,
          data_type:,
          period_from:,
          period_to:,
          ios_data_requester: ExternalServices::Shipdc::IosData
        )
          @imo_no = imo_no
          @data_type = data_type
          @period_from = period_from
          @period_to = period_to
          @ios_data_requester = ios_data_requester
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
            Analytic::SimServices::Importing::SimMetadata.new(
              imo_no: @imo_no,
              data_type: @data_type,
              revno: revno,
            ).()
          end
        end

        def processing_rows
          ios_data.each do |row|
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
          Analytic::Sim.collection.insert_many(records)
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
          body = @ios_data_requester.new(@imo_no, {
            dataType: @data_type,
            from: @period_from.strftime('%FT%TZ'),
            to: @period_to.strftime('%FT%TZ')
          }).fetch
          body[:data]
        end
      end
    end
  end
end
