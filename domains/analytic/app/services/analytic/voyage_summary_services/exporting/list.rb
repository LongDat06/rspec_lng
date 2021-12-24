module Analytic
  module VoyageSummaryServices
    module Exporting
      class ListError < StandardError; end

      class List
        def initialize(params: {})
          @options = {}
          options[:imo] = params[:imo]
          options[:from_time] = params[:from_to]
          options[:to_time] = params[:to_time]
          options[:port_dept] = params[:port_dept]
          options[:port_arrival] = params[:port_arrival]
          options[:voyage_no] = params[:voyage_no]
          options[:voyage_leg] = params[:voyage_leg]
          options[:sort_by] = params[:sort_by]
          options[:sort_order] = params[:sort_order]
        end

        def call
          csv_enumerator
          upload_to_s3.url(response_content_disposition: ContentDisposition.attachment(file_name))
        rescue StandardError => e
          raise ListError, e
        ensure
          remove_local_file
        end

        private

        attr_reader :options

        def csv_enumerator
          CSV.open(csv_tmp_file, 'w') do |writer|
            writer << mapping_fields.keys
            voyage_summaries.each do |item|
              writer << mapping_fields.map { |_, field| item.send(field) }
            end
          end
        end

        def upload_to_s3
          uploader = Analytic::Uploader::TemporaryUploader.new(:cache)
          uploader.upload(File.open(csv_tmp_file))
        end

        def mapping_fields
          {
            'Vessel': 'vessel_name',
            'Voyage No.': 'voyage_name',
            'Departure Port': 'port_dept',
            'Arrival Port': 'port_arrival',
            'ATD (LT)': 'atd_lt_display',
            'ATA (LT)': 'ata_lt_display',
            'Distance (miles)': 'distance',
            'Duration (hours)': 'duration',
            'Avg. Speed (knot)': 'average_speed',
            'LNG Cons. (MT)': 'lng_consumption',
            'MGO Cons. (MT)': 'mgo_consumption',
            'Avg. BOR (%/day)': 'average_boil_off_rate',
            'Actual Heel (m3)': 'actual_heel',
            'Estimated Heel (m3)': 'estimated_heel',
            'Cargo Vol. on Arrival (m3)': 'cargo_volume_at_port_of_arrival',
            'ADQ (m3)': 'adq',
            'EDQ (m3)': 'estimated_edq'
          }
        end

        def voyage_summaries
          @voyage_summaries ||= Analytic::VoyageSummaryServices::List.new(params: options).fetch
        end

        def file_name
          @file_name ||= "voyage_summary_#{Time.current.to_i}.csv"
        end

        def csv_tmp_file
          @csv_tmp_file ||= "#{ENV['SHARED_TMP']}/#{file_name}"
        end

        def remove_local_file
          FileUtils.rm_f(csv_tmp_file)
        end
      end
    end
  end
end
