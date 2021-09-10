namespace :migrate_data do
  desc "MIGRATE FOR DOWNLOAD TEMPLATE"
  task download_template: :environment do
    logger ||= Logger.new("#{Rails.root}/log/migrate_template.log")
    logger.info("----------START_migrate------------")
    Analytic::DownloadTemplate.all.each do |template|
      logger.info("----------template name:-- #{template.name}--")
      next if !template.channels.present? || template.channels.is_a?(Array)
      channels = template.channels.to_h
      imo_no = template.imo_no
      update_channels = {}
      channels.each do |sname, lname|
        channel = Analytic::SimChannel.where(standard_name: sname, local_name: lname, imo_no: imo_no).first
        unless channel.present?
          logger.info("------NOT FOUND:----Channel with standard_name: #{sname} and local_name: #{lname} and imo: #{imo_no} does not exist")
        else
          update_channels[channel._id.to_s] = lname
        end
      end
      next unless update_channels.present?
      template.bk_channels = channels
      template.channels = update_channels
      template.save
    end
    logger.info("----------END_migrate--------------")
  end
end
