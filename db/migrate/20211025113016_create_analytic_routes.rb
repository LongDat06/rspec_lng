class CreateAnalyticRoutes < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_routes do |t|
      t.string :port_1
      t.string :port_2
      t.string :pacific_route
      t.string :detail
      t.integer :distance
      t.integer :created_by, index: true
      t.integer :updated_by, index: true
      t.timestamps
    end
    add_index :analytic_routes, [:port_1, :port_2]
    add_index :analytic_routes, :port_1
  end
end
