module Analytic
  module GenreServices
    module Exporting
      class GenreChannelNotFoundErrorReportXlsxError < StandardError; end
      class GenreChannelNotFoundErrorReportXlsx

        def initialize(imo:, unknown_stdnames: [], missing_stdnames: [])
          @imo = imo
          @unknown_stdnames = unknown_stdnames
          @missing_stdnames = missing_stdnames
        end

        def call
          excel_enumerator
          vessel.genre_error_reporting = File.open(excel_tmp_file)
          vessel.save!
        rescue => e
          raise GenreChannelNotFoundErrorReportXlsxError, e
        ensure
          remove_local_file
        end

        private
        def excel_enumerator
          sheets = {
            'Unknown StdName' => @unknown_stdnames,
            'Missing StdName' => @missing_stdnames
          }
          headers = ["Standard Name", "Genre"]
          XlsxWriter::Workbook.new(excel_tmp_file) do |wb|
            sheets.each do |name, data|
              next if data.empty?

              wb.add_worksheet(name) do |ws|
                ws.add_row(headers)
                data.each do |item|
                  ws.add_row(item)
                end
              end
            end
          end
        end

        def excel_tmp_file
          @excel_tmp_file ||= begin
            "#{ENV['SHARED_TMP']}/#{@imo}_genre_mapping_error_reporting_#{Time.current.to_i}.xlsx"
          end
        end

        def vessel
          @vessel ||= Analytic::Vessel.find_by(imo: @imo)
        end

        def remove_local_file
          FileUtils.rm_f(excel_tmp_file)
        end

      end
    end
  end
end
