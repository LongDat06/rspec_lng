class ChangeColumnetaetdVoyageSummary < ActiveRecord::Migration[6.0]
  def change
    rename_column :analytic_voyage_summaries, :etd_lt,  :atd_lt
    rename_column :analytic_voyage_summaries, :etd_utc, :atd_utc
    rename_column :analytic_voyage_summaries, :eta_utc, :ata_utc
    rename_column :analytic_voyage_summaries, :eta_lt,  :ata_lt
  end
end
