module Ais
  class ImportVesselDestinationSpasListener
    def on_spas_import_successful(spas_datas)
      import_ais(spas_datas)
    end

    private
    def import_ais(data)
      Ais::VesselDestination.import!(vessel_destination_columns, data)
    end

    def vessel_destination_columns
      [:imo, :draught, :eta, :destination, :last_ais_updated_at, :source]
    end
  end
end
