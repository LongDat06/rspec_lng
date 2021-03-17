require 'gmail'

module Ais
  module Ecdis
    class MailChecker
      USERNAME        = ENV['ECDIS_GMAIL_USERNAME']
      PASSWORD        = ENV['ECDIS_GMAIL_PASSWORD']
      TEMP_FILE_PATH  = "#{ENV['SHARED_TMP']}/ecdis_attachment_"

      def call
        process
      end

      private

      def gmail
        @gmail ||= Gmail.new(USERNAME, PASSWORD)
      end

      def unread_messages
        gmail.inbox.emails(:unread)
      end

      def store_attachment(attachment, file_path)
        File.open(file_path, 'w') do |file|
          file.write(attachment.decoded)
        end
      end

      def remove_attachment(file_path)
        File.delete(file_path)
      end

      def string_time_now
        Time.now.to_s.gsub!(/[\s,:]/, '_')
      end

      def file_name_with_time_now
        "#{TEMP_FILE_PATH}#{string_time_now}.txt"
      end

      def attachments_processor(received_at, attachments, vessel)
        attachments.each do |attachment|
          filepath = file_name_with_time_now
          filename = attachment.filename
          store_attachment(attachment, filepath)

          Ais::Ecdis::Import.new(
            received_at: received_at,
            filepath: filepath,
            filename: filename,
            vessel: vessel
          ).call

          remove_attachment(filepath)
        end
      end

      def logout
        gmail.logout
      end

      def process
        unread_messages.each do |email|
          from = email.from
          vessel = Ais::Vessel.find_by(target: true, ecdis_email: from)
          
          if vessel.blank?
            email.mark(:unread)
            next
          end

          received_at = email.received.first.value.split(/\r\n/).second.strip
          attachments = email.attachments
          attachments_processor(received_at, attachments, vessel)
        end

        logout
      end
    end
  end
end
