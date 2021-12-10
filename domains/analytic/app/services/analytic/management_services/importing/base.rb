module Analytic
  module ManagementServices
    module Importing
      class Base
        attr_accessor :file_metadata, :user_id, :error_rows
        def initialize(file_metadata, user_id)
          @file_metadata = file_metadata
          @user_id = user_id
          @error_rows = []
        end

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
      end
    end
  end
end
