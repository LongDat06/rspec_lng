module CleanShipdcData
  def clear_old_related_sim_table(imo)
    Analytic::Sim.where(imo_no: imo).delete_all
    Analytic::SimChannel.where(imo_no: imo).delete_all
    Analytic::SimMetadata.where(imo_no: imo).delete_all
    Analytic::VoyageSummary.where(imo: imo).delete_all
  end
end

