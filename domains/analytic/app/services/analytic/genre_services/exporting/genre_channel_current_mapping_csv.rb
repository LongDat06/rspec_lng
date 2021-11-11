module Analytic
  module GenreServices
    module Exporting
      class GenreChannelCurrentMappingCsvError < StandardError; end
      class GenreChannelCurrentMappingCsv

        def initialize(imo:)
          @imo = imo
        end

        def call
          csv_enumerator
          file = File.open(csv_tmp_path)
          uploaded_file  = Analytic::Uploader::TemporaryUploader.upload(file, :cache)
          uploaded_file.url(response_content_disposition: ContentDisposition.attachment(file_name))
        ensure
          remove_local_file
        end

        private
        def csv_enumerator
          CSV.open(csv_tmp_path, 'w') do |writer|
            writer << ['Standard Name', 'Genre']
            channel_data.each do |channel|
              writer << [channel.iso_std_name, channel.genre]
            end
          end
        end

        def csv_tmp_path
          @csv_tmp_path ||= begin
            "#{ENV['SHARED_TMP']}/#{file_name}"
          end
        end

        def file_name
          @file_name ||= "#{@imo}_genre_channel_#{Time.current.to_i}.csv"
        end

        def channel_data
          @channel_data ||= Analytic::SimChannel.where(imo_no: @imo).only(:iso_std_name, :genre)
        end

        def remove_local_file
          FileUtils.rm_f(csv_tmp_path)
        end

      end
    end
  end
end
