class MasterPorts < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_master_ports do |t|
      t.string :name
      t.integer :created_by, index: true
      t.string :time_zone
      t.timestamps
    end
  end
end
