module ImportOldestSimData
  def get_oldest_sim_date(imo, sim_data_type)
    data = Analytic::ExternalServices::Shipdc::DataSet.new.fetch
    ios_data_set = data[:iosData].select do |item|
      item[:shipId].to_i == imo &&
      item[:dataType] == sim_data_type
    end.sort { |current, previous| current[:availableFrom] <=> previous[:availableFrom] }
    ios_data_set[0][:availableFrom]&.to_datetime if ios_data_set.present?
  end

  def import_sim_from_past(imo, oldest_date, sim_data_type)
    range = (oldest_date.beginning_of_day..Time.current.end_of_day)
    Analytic::UtilityServices::RailsDateRange.new(range).().every(days: 1).each do |time|
      Analytic::SimJob::IosDataVerifyJob.perform_later(imo, time, false, true, 'day')
    end
  end
end
