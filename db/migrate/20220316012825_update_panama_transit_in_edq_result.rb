class UpdatePanamaTransitInEdqResult < ActiveRecord::Migration[6.0]
  def change
    rename_column :analytic_edq_results,  :heel_leg1, :cosuming_lng_of_ballast_voyage_leg1
    rename_column :analytic_edq_results,  :heel_leg2, :cosuming_lng_of_ballast_voyage_leg2
    rename_column :analytic_edq_results,  :heel, :cosuming_lng_of_ballast_voyage
    add_column :analytic_edq_results, :estimated_heel_leg1, :float, null: true
    add_column :analytic_edq_results, :estimated_heel_leg2, :float, null: true
  end
end
