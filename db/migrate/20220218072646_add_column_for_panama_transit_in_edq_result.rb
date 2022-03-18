class AddColumnForPanamaTransitInEdqResult < ActiveRecord::Migration[6.0]
  def change
    add_column :analytic_edq_results, :laden_pa_transit, :boolean, null: false, default: false
    add_column :analytic_edq_results, :ballast_pa_transit, :boolean, null: false, default: false
    add_column :analytic_edq_results, :landen_fuel_consumption_in_pa, :float, null: true
    add_column :analytic_edq_results, :ballast_fuel_consumption_in_pa, :float, null: true
    add_column :analytic_edq_results, :sea_margin, :float, null: false, default: 0
    add_column :analytic_edq_results, :cosuming_lng_of_laden_voyage_leg1, :float, null: true
    add_column :analytic_edq_results, :cosuming_lng_of_laden_voyage_leg2, :float, null: true
    add_column :analytic_edq_results, :heel_leg1, :float, null: true
    add_column :analytic_edq_results, :heel_leg2, :float, null: true
    rename_column :analytic_edq_results, :laden_voyage_id, :laden_voyage_leg1_id
    rename_column :analytic_edq_results, :ballast_voyage_id, :ballast_voyage_leg1_id
    add_reference :analytic_edq_results, :laden_voyage_leg2, foreign_key: { to_table: :analytic_heel_results },
                                                             index: true, null: true
    add_reference :analytic_edq_results, :ballast_voyage_leg2, foreign_key: { to_table: :analytic_heel_results },
                                                               index: true, null: true
    remove_column :analytic_heel_results, :port_dept, :string
    remove_column :analytic_heel_results, :port_arrival, :string
    remove_column :analytic_heel_results, :pacific_route, :string

  end
end
