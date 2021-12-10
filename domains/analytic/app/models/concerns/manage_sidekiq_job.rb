module ManageSidekiqJob
  def create_schedule_jobs(imo, time_from = Time.current.utc, time_to = Time.current.end_of_day)
    Analytic::SimJob::ImportingJob.perform_later(time_from, time_to, [imo])
  end

  def delete_schedule_jobs(imo)
    scheduled_jobs = Sidekiq::ScheduledSet.new
    scheduled_jobs.select do |a|
      obj = JSON.parse(a.value).symbolize_keys
      obj[:wrapped] == "Analytic::SimJob::IosDataVerifyJob" && obj[:args].first["arguments"].first == imo
    end.map(&:delete)
  end
end

