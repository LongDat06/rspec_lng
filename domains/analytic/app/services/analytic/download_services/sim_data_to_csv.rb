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
            .only(*standard_name_columns.map{|column| "spec.#{column}" } << "spec.ts")
        end
      end

      def csv_enumerator
        CSV.open(csv_tmp_file, 'w') do |writer|
          writer << header_combinations
          writer << stdname_rows if @condition[:included_stdname].present?
          writer << unit_rows
          sim_data.each do |row|
            writer << row_combinations(row.spec)
          end
        end
      end

      def row_mapping(spec)
        channels.pluck(:standard_name).map do |column|
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
        @headers ||= channels.pluck(:local_name)
      end

      def channels
        @channels ||= Analytic::SimChannel.where(imo_no: @imo, :_id.in => exporting_columns).order('local_name' => 1)
      end

      def unit_rows
        @unit_rows ||= begin
          units = channels.pluck(:unit)
          fixed_left_columns.map {|_| ''}.concat(ts_column.map {|_| ''}, units)
        end
      end

      def stdname_rows
        std_names = channels.pluck(:iso_std_name)
        fixed_left_columns.map {|_| ''}.concat(ts_column.map {|_| ''}, std_names)
      end

      def header_combinations
        left_header = fixed_left_columns.keys
        ts_header    = ts_column.map {|key, _| key }
        left_header.concat(ts_header, headers)
      end

      def row_combinations(spec)
        left_column_value = fixed_left_columns.values
        ts_column_value    = ts_column(spec.attributes).map { |_, value| value }
        left_column_value.concat(ts_column_value,row_mapping(spec))
      end

      def ts_column(attributes = [])
        {
          'UTC' => attributes.present? ? attributes['ts'] : ''
        }
      end

      def fixed_left_columns
        {
          'Vessel Name' => @vessel_name,
        }
      end

      def exporting_columns
        @exporting_columns ||= @condition.columns.keys
      end

      def standard_name_columns
        @standard_name_columns ||= @channels.pluck(:standard_name)
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
