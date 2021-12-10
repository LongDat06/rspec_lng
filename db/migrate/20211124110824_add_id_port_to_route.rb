class AddIdPortToRoute < ActiveRecord::Migration[6.0]
  def change
    add_column :analytic_routes, :port_1_id, :integer
    add_column :analytic_routes, :port_2_id, :integer
    add_column :analytic_routes, :master_route_id, :integer
    add_column :analytic_master_ports, :country_code, :string
    add_index :analytic_routes, [:port_1_id, :port_2_id, :master_route_id], unique: true, name: 'port_route_index'
    # remove_column :analytic_routes, :id_port_1
    # remove_column :analytic_routes, :id_port_2
  end
end
