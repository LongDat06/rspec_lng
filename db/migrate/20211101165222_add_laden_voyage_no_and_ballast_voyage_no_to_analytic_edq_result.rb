class AddLadenVoyageNoAndBallastVoyageNoToAnalyticEdqResult < ActiveRecord::Migration[6.0]
  def change
    add_column :analytic_edq_results, :laden_voyage_no, :string, null: false
    add_column :analytic_edq_results, :ballast_voyage_no, :string, null: false
  end
end
