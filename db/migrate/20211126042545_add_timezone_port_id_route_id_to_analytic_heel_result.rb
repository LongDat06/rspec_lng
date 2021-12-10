class AddTimezonePortIdRouteIdToAnalyticHeelResult < ActiveRecord::Migration[6.0]
  def change
    add_column :analytic_heel_results, :etd_time_zone, :string
    add_column :analytic_heel_results, :eta_time_zone, :string
    add_reference :analytic_heel_results, :port_dept, index: true, foreign_key: { to_table: :analytic_master_ports }
    add_reference :analytic_heel_results, :port_arrival, index: true, foreign_key: { to_table: :analytic_master_ports }
    add_reference :analytic_heel_results, :master_route, index: true, foreign_key: { to_table: :analytic_master_routes }
    change_column :analytic_heel_results, :port_dept, :string, null: true
    change_column :analytic_heel_results, :port_arrival, :string, null: true
    change_column :analytic_heel_results, :pacific_route, :string, null: true
  end
end
