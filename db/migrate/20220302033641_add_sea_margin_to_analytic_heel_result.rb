class AddSeaMarginToAnalyticHeelResult < ActiveRecord::Migration[6.0]

  def change
    add_column :analytic_heel_results, :sea_margin, :float, null: false, default: 0
    remove_column :analytic_edq_results, :sea_margin, :float, null: false, default: 0
  end
end
