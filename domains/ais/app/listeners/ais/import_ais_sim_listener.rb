module Ais
  class ImportAisSimListener
    def on_sim_import_successful(sim_datas)
      import_ais(sim_datas)
    end

    private
    def import_ais(data)
      Ais::Tracking.import!(tracking_columns, data.reject { |item| item[:latitude].blank? || item[:longitude].blank? })
    end

    def tracking_columns
      [:imo, :latitude, :longitude, :speed_over_ground, :heading, :is_valid, :last_ais_updated_at, :source]
    end
  end
end
