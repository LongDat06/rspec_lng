class GenerateSchedule
  def initialize
    jobs
  end

  def call
    jobs.each do |job|
      push_to_schedule(job["class_name"], job["interval"], job["start_at"], job["params"])
    end
  end

  private

  def push_to_schedule(class_name, interval, start_at, params = nil)
    job = class_name.constantize

    if exec_at_once?(interval, start_at)
      valid?(start_at) && push_to_schedule_at(job, start_at, params) 
      return
    end
    
    if exec_at_multiple?(interval, start_at)
      start_at.each { |time| valid?(time) && push_to_schedule_at(job, time, params) }
      return
    end

    run_at = in_minute(Time.zone.parse(start_at))
    (run_at...1440).step(interval).each { |start_in| valid_interval?(start_in) && push_to_schedule_in(job, start_in, params) }
  end

  def valid?(start_at)
    start_at.present? && 10.minutes.ago < Time.zone.parse(start_at)
  end

  def valid_interval?(start_in)
    start_in.present? && 10.minutes.ago < min_to_time(start_in)
  end

  def exec_at_once?(interval, start_at)
    interval.nil? && start_at.class != Array
  end

  def exec_at_multiple?(interval, start_at)
    interval.nil? && start_at.class == Array
  end

  def min_to_time(num = 0)
    Time.zone.parse("00:00") + num.minute
  end

  def in_minute(timestamp)
    timestamp.hour * 60 + timestamp.min
  end

  def push_to_schedule_at(job, start_at, params)
    job.set(wait_until: Time.zone.parse((start_at))).perform_later(*params)
  end

  def push_to_schedule_in(job, start_in, params)
    job.set(wait: start_in.minutes).perform_later(*params)
  end

  def jobs
    @jobs ||= YAML.load_file(Rails.root.join('domains/analytic/config/schedule', "#{Rails.env}.yml"))
  end
end
