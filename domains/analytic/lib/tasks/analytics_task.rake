# desc "Explaining what the task does"
# task :analytic do
#   # Task goes here
# end

"Exec day by day"
task run_daily_schedule: :environment do
  GenerateSchedule.new.()
end