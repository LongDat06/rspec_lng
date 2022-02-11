class AddManualFieldsToAnalyticVoyageSummary < ActiveRecord::Migration[6.0]
  def change
    add_column :analytic_voyage_summaries, :manual_port_dept, :string
    add_column :analytic_voyage_summaries, :manual_port_arrival, :string
    add_column :analytic_voyage_summaries, :manual_atd_lt, :datetime
    add_column :analytic_voyage_summaries, :manual_ata_lt, :datetime
    add_column :analytic_voyage_summaries, :manual_atd_utc, :datetime
    add_column :analytic_voyage_summaries, :manual_ata_utc, :datetime
    add_column :analytic_voyage_summaries, :manual_ata_time_zone, :string
    add_column :analytic_voyage_summaries, :manual_atd_time_zone, :string
    add_column :analytic_voyage_summaries, :manual_distance, :integer
    add_column :analytic_voyage_summaries, :manual_duration, :integer
    add_column :analytic_voyage_summaries, :manual_average_speed, :float
  end
end
