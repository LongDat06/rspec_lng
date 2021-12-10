module Analytic
  module SimServices
    class BackupTemplateBeforeReimport
      def call
        logger ||= Logger.new("#{Rails.root}/log/backup_channels.log")
        logger.info("----------START Backup channels------------")
        Analytic::DownloadTemplate.all.each do |template|
          logger.info("----------template name:-- #{template.name}--")
          next if !template.channels.present? || template.channels.is_a?(Array)
          channels = template.channels.to_h
          imo_no = template.imo_no
          update_channels = {}
          channels.each do |channel_id, lname|
            channel = Analytic::SimChannel.where(_id: channel_id).first
            unless channel.present?
              logger.info("------NOT FOUND:----Channel with local_name: #{lname} and imo: #{imo_no} does not exist")
            else
              update_channels[channel.standard_name] = lname
            end
          end
          next unless update_channels.present?
          template.bk_channels = update_channels
          template.save
        end
        logger.info("----------END_migrate--------------")
      end
    end
  end
end
