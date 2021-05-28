module Analytic
  module DownloadServices
    class SimDataToCsv
      def initialize(imo:, condition:, download_job:)
        @condition = condition
        @imo = imo
        @download_job = download_job
      end

      def call
        begin
          csv_enumerator
          @download_job.content = File.open(csv_tmp_file)
          @download_job.save!
        ensure
          remove_local_file
        end
      end

      private
      def sim_data
        @sim_data ||= begin
          Analytic::Sim
            .order_by('spec.ts' => 1)
            .where(imo_no: @imo)
            .where({'spec.ts' => { 
              '$gte' => @condition[:timestamp_from_at], '$lte' => @condition[:timestamp_to_at]
            }})
            .only(*exporting_columns.map{|column| "spec.#{column}" } << "spec.ts")
        end
      end

      def csv_enumerator
        CSV.open(csv_tmp_file, 'w') do |writer|
          writer << (headers.concat(fixed_columns.map {|key, _| key }))
          sim_data.each do |row|
            writer << (row_mapping(row.spec).concat(fixed_columns((row.spec.attributes)).map {|_, value| value }))
          end
        end
      end

      def row_mapping(spec)
        exporting_columns.map do |column|
          spec.attributes[column]
        end
      end

      def csv_tmp_file
        @csv_tmp_file ||= begin
          "#{ENV['SHARED_TMP']}/sims_download_#{time_format(Time.current.to_s)}_#{vessel_name}_#{time_format(@condition[:timestamp_from_at])}-#{time_format(@condition[:timestamp_to_at])}.csv"
        end
      end

      def time_format(datetime)
        datetime.to_datetime.strftime("%FT%T")
      end

      def headers
        @headers ||= @condition.columns.values
      end

      def fixed_columns(attributes = [])
        {
          'Vessel Name' => @vessel_name,
          'Timestamp' => attributes.present? ? attributes['ts'] : ''
        }
      end

      def exporting_columns
        @exporting_columns ||= @condition.columns.keys
      end

      def vessel_name
        @vessel_name ||= Analytic::Vessel.find_by(imo: @imo)&.name
      end

      def remove_local_file
        File.delete(csv_tmp_file)
      end
    end
  end
end
