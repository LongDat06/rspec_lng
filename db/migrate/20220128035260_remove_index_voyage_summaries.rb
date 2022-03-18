class RemoveIndexVoyageSummaries < ActiveRecord::Migration[6.0]
  def change
    remove_index :analytic_voyage_summaries, name: "analytic_voyage_summaries_uniq_idx"
  end
end
