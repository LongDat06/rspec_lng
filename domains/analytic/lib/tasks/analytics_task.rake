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
