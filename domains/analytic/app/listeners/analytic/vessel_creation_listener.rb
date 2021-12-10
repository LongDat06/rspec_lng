module Analytic
  class VesselCreationListener
    include ImportOldestSimData
    def on_vessel_create_successful(imo, sim_data_type)
      Analytic::SpasServices::LastDeparture.new(imo).()
      @sim_data_type = sim_data_type
      oldest_sim_date = get_oldest_sim_date(imo, sim_data_type)
      oldest_spas_date = get_oldest_spas_date(imo)
      if oldest_sim_date.present?
        create_channels(imo)
        import_sim_from_past(imo, oldest_sim_date, sim_data_type)
      end
      import_spas_from_past(imo, oldest_spas_date) if oldest_spas_date.present?
    end

    private
    attr_reader :sim_data_type
    def import_spas_from_past(imo, oldest_date)
      range = (oldest_date.beginning_of_day..Time.current.end_of_day)
      Analytic::UtilityServices::RailsDateRange.new(range).().every(days: 1).each do |time|
        Analytic::SpasJob::RepDataVerifyJob.perform_later(imo, time, false, true)
      end
    end

    def get_oldest_spas_date(imo)
      data = Analytic::ExternalServices::Shipdc::DataSet.new.fetch
      ios_data_set = data[:repData].select do |item|
        item[:shipId].to_i == imo &&
        item[:dataType] == 'AtSeaReport'
      end.sort { |current, previous| current[:availableFrom] <=> previous[:availableFrom] }
      ios_data_set[0][:availableFrom]&.to_datetime if ios_data_set.present?
    end

    def create_channels(imo)
      Analytic::SimJob::ImportChannelJob.perform_later(imo)
    end
  end
end
