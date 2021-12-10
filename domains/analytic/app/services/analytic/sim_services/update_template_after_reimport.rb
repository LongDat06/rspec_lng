module Analytic
  module SimServices
    class UpdateTemplateAfterReimport
      def call
        logger ||= Logger.new("#{Rails.root}/log/update_new_channels.log")
        logger.info("----------START Update new from new datatype------------")
        Analytic::DownloadTemplate.all.each do |template|
          logger.info("----------template name:-- #{template.name}--")
          next if !template.bk_channels.present? || template.bk_channels.is_a?(Array)
          bk_channels = template.bk_channels.to_h
          imo_no = template.imo_no
          update_channels = {}
          bk_channels.each do |sname, lname|
            channel = Analytic::SimChannel.where(standard_name: sname).first
            unless channel.present?
              logger.info("------NOT FOUND:----Channel with local_name: #{sname} and imo: #{imo_no} does not exist")
            else
              update_channels[channel._id.to_s] = lname
            end
          end
          next unless update_channels.present?
          template.channels = update_channels
          template.save
        end
        logger.info("----------END_migrate--------------")
      end
    end
  end
end
