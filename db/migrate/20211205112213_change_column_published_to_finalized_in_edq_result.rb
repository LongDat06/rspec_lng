class ChangeColumnPublishedToFinalizedInEdqResult < ActiveRecord::Migration[6.0]

  def change
    rename_column :analytic_edq_results, :published, :finalized
  end

end
