class AddLegIdToVoyageSummary < ActiveRecord::Migration[6.0]
  def change
  	add_column :analytic_voyage_summaries, :leg_id, :integer, default: 1
  	add_index :analytic_voyage_summaries, %i(imo voyage_no voyage_leg leg_id), unique: true, name: :analytic_voyage_summaries_4fields_uniq_idx
  end
end
