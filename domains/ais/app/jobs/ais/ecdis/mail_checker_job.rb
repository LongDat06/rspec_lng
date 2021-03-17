module Ais
  module Ecdis
    class MailCheckerJob < ApplicationJob
      queue_as :ecdis_mail_checker
      
      def perform
        Ais::Ecdis::MailChecker.new.()
      end
    end
  end
end
