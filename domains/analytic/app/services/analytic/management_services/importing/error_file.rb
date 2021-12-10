module Analytic
  module ManagementServices
    module Importing
      class ErrorFile
        attr_accessor :user_id, :error_rows, :source
        def initialize(user_id, source, error_rows = [])
          @user_id = user_id
          @error_rows = error_rows
          @source = source
        end

        def call
          tracking_file = Analytic::ReportFile.find_or_create_by(source: source)
          if error_rows.present?
            error_content_file(local_path)
            tracking_file.update(file_content: File.open(local_path), user_id: user_id)
            remove_local_file
          else
            #Delete file from s3
            tracking_file.file_content&.delete
            tracking_file.update(file_content: nil)
          end
        end

        private

        def error_content_file(file_path)
          header = if source == "foc"
            foc_header
          else
            route_header
          end
          XlsxWriter::Workbook.new(file_path) do |wb|
            wb.add_worksheet('Sheet 1') do |ws|
              ws.add_row(header, style: :header)
              error_rows.each do |row|
                ws.add_row(row, style: [:num])
              end
            end
          end
          file_path
        end

        def local_path
          "#{ENV['SHARED_TMP']}/invalid_#{source.to_s}_report.xlsx"
        end

        def remove_local_file
          FileUtils.rm_f(local_path)
        end

        def route_header
          ['Port Name 1', 'Port Name 2', 'Route', 'Estimated Distance (NM)', 'Route Detail', 'Error Message']
        end

        def foc_header
          ['IMO', 'Speed (knot)', 'Laden FOC (MT/day)', 'Ballast FOC (MT/day)', 'Error Message']
        end
      end
    end
  end
end
