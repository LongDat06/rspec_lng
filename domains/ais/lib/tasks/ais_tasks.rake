"Exec day by day"
task run_ais_daily_schedule: :environment do
  Ais::GenerateSchedule.new.()
end
