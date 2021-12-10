module CleanShipdcData
  def clear_old_related_sim_table(imo)
    Analytic::Sim.where(imo_no: imo).destroy_all
    Analytic::SimChannel.where(imo_no: imo).destroy_all
    Analytic::SimMetadata.where(imo_no: imo).destroy_all
  end
end

