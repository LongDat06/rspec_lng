class CreateMasterRoutes < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_master_routes do |t|
      t.string :name
      t.integer :created_by, index: true
      t.timestamps
    end
  end
end
