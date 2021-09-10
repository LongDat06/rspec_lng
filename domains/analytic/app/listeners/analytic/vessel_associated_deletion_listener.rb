module Analytic
  class VesselAssociatedDeletionListener
    def on_vessel_delete_successful(imo)
      Analytic::Sim.where(imo_no: imo).delete_all
      Analytic::Spas.where(imo_no: imo).delete_all
      Analytic::SimChannel.where(imo_no: imo).delete_all
    end
  end
end
