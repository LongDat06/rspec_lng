module Analytic
  class VesselAssociatedDeletionListener
    include ManageSidekiqJob
    include CleanShipdcData
    def on_vessel_delete_successful(imo)
      clear_old_related_sim_table(imo)
      delete_schedule_jobs(imo)
    end
  end
end
