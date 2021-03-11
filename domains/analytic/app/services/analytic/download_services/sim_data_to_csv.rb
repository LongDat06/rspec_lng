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
          csv_enumerator.each do |item|
            csv_tmp_file << item
          end
          @download_job.content = csv_tmp_file
          @download_job.save!
        ensure
          csv_tmp_file.close
          csv_tmp_file.unlink
        end
      end

      private
      def sim_data
        @sim_data ||= begin
          Analytic::Sim
            .order_by('spec.timestamp' => 1)
            .where(imo_no: @imo)
            .where({'spec.timestamp' => { 
              '$gte' => @condition[:timestamp_from_at], '$lte' => @condition[:timestamp_to_at]
            }})
            .only(*exporting_columns.map{|column| "spec.#{column}" })
        end
      end

      def csv_enumerator
        @csv_enumerator ||= Enumerator.new do |yielder|
          yielder << CSV.generate_line(headers)

          sim_data.each do |row|
            yielder << CSV.generate_line(row_mapping(row.spec))
          end
        end
      end

      def row_mapping(spec)
        exporting_columns.map do |column|
          spec.attributes[column]
        end
      end

      def csv_tmp_file
        @csv_tmp_file ||= Tempfile.new(["raw_sim_data_#{Time.current}", ".csv"])
      end

      def headers
        @headers ||= @condition.columns.values
      end

      def exporting_columns
        @exporting_columns ||= @condition.columns.keys
      end
    end
  end
end
