# Daily generate job for AIS domain #
every :day, roles: [:app] do
  rake 'run_ais_daily_schedule'
end

# Daily generate job for ANALYTIC domain #
every :day, roles: [:app] do
  rake 'run_analytic_daily_schedule'
end
