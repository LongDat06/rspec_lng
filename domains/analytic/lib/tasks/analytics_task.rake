# desc "Explaining what the task does"
# task :analytic do
#   # Task goes here
# end

"Exec day by day"
task run_analytic_daily_schedule: :environment do
  GenerateSchedule.new.()
end

desc "call: rake importing_routes FILE_NAME='RouteList.csv' "
task importing_routes: :environment do
  Analytic::ImportingJob::RouteJob.perform_later(ENV["FILE_NAME"])
end

desc "call: rake importing_focs FILE_NAME='TCP_FOC_Table.csv' "
task importing_focs: :environment do
  Analytic::ImportingJob::FocJob.perform_later(ENV["FILE_NAME"])
end

desc "Call manually after updating Sim Data Type"
task update_all_default_shipdata_to_target_vessel: :environment do
  Ais::Vessel.target(true).update_all(sim_data_type: Analytic::Sim::DATA_TYPE)
end

task backup_channels_download_template: :environment do
  Analytic::SimServices::BackupTemplateBeforeReimport.new.()
end

desc "call: rake reimport_sim_data_for_vessel IMO=[imo_no], DATA_TYPE=[sum_data_type] "
task reimport_sim_data_for_vessel: :environment do
  Analytic::SimJob::ReimportingJob.perform_later(ENV["IMO"], ENV["DATA_TYPE"])
end

task update_new_channels_download_template: :environment do
  Analytic::SimServices::BackupTemplateAfterReimport.new.()
end
