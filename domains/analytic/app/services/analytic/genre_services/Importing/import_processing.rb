module Analytic
  module GenreServices
    module Importing
      class ImportProcessingError < StandardError; end
      class ImportProcessing
        include Wisper::Publisher

        def initialize(imo:, file_metadata: {})
          @imo = imo
          @file_metadata = file_metadata
        end

        def call
          import_genre
          Analytic::GenreServices::ChannelMappingProcessing.new(imo: @imo, job_id: job_id).()
          uploaded_file.delete
        rescue => e
          broadcast(:on_failed_error_report, { imo: @imo, errors: [e.message], job_id: job_id })
          raise ImportProcessingError, e
        ensure
          temp_file.close! if temp_file.present?
        end

        private
        def uploaded_file
          @uploaded_file ||= Analytic::Uploader::TemporaryUploader.uploaded_file(@file_metadata)
        end

        def job_id
          @job_id ||= uploaded_file.id
        end

        def temp_file
          @temp_file ||= uploaded_file.download
        end

        def file_path
          @file_path ||= temp_file.path
        end

        def data_sheet
          @data_sheet ||= Creek::Book.new(file_path)
        end

        def rows
          @rows ||= data_sheet.sheets.first.simple_rows
        end

        def import_genre
          Analytic::Genre.transaction do
            Analytic::Genre.where(imo: @imo).destroy_all
            Analytic::Genre.import build_genres, recursive: true, validate: false
          end
        end

        def genre_items_parser
          @genre_items_parser ||= begin
            genres = {}
            rows.drop(1).each.with_index(1) do |row, index|
              next if row.blank?
              standard_name = row['C'].to_s.strip

              raise ImportProcessingError, "Rows: #{index + 1}. Standard Name cannot be blank." if standard_name.blank?

              genre_name = row['D'].to_s.strip.presence || Analytic::Genre::OTHER_NAME
              genres[genre_name] ||= Set.new
              genres[genre_name] << { iso_std_name: standard_name }
            end
            genres
          end
        end

        def build_genres
          genres = []
          genre_items_parser.each do |genre_name, standard_names|
            genre =  Analytic::Genre.new(imo: @imo, name: genre_name)
            genre.genre_sim_channels.build(standard_names.to_a)
            genres << genre
          end
          genres << Analytic::Genre.new(imo: @imo, name: Analytic::Genre::NOT_AVAILABLE_TYPE) if genres.present?
          genres
        end

      end
    end
  end
end
