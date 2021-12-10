class AddMoreIndexToRoute < ActiveRecord::Migration[6.0]
  def change
    add_index :analytic_routes, [:port_1, :port_2, :pacific_route], unique: true
  end
end
