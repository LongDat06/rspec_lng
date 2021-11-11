module Analytic
  module GenreServices
    module Exporting
      class GenreChannelErrorReportError < StandardError; end
      class GenreChannelErrorReportCsv

        def initialize(imo:, errors: [])
          @imo = imo
          @errors = errors
        end

        def call
          csv_enumerator
          vessel.genre_error_reporting = File.open(csv_tmp_file)
          vessel.save!
        rescue => e
          raise GenreChannelErrorReportError, e
        ensure
          remove_local_file
        end

        private
        def csv_enumerator
          CSV.open(csv_tmp_file, 'w') do |writer|
            writer << ['Errors']
            @errors.each do |report|
              writer << [report]
            end
          end
        end

        def csv_tmp_file
          @csv_tmp_file ||= begin
            "#{ENV['SHARED_TMP']}/#{@imo}_error_reporting_#{Time.current.to_i}.csv"
          end
        end

        def vessel
          @vessel ||= Analytic::Vessel.find_by(imo: @imo)
        end

        def remove_local_file
          FileUtils.rm_f(csv_tmp_file)
        end

      end
    end
  end
end
