module Analytic
  module ManagementServices
    module Exporting
      class Base
        include ShrineStore
        def call
          export(local_path)
          url = upload_temporary_file(local_path)
          remove_local_file
          url
        end

        def export(file_path)
          XlsxWriter::Workbook.new(file_path) do |wb|
            wb.add_worksheet('Sheet 1') do |ws|
              ws.add_row(header)
              rows.each do |row|
                ws.add_row(row, style: [:num])
              end
            end
          end
          file_path
        end

        def local_path
          @local_path ||= "#{ENV['SHARED_TMP']}/#{file_name}"
        end

        def remove_local_file
          FileUtils.rm_f(local_path)
        end

        def header
          raise "Defined on child class"
        end

        def rows
          raise "Defined on child class"
        end

        def file_name
          raise "Defined on child class"
        end
      end
    end
  end
end
