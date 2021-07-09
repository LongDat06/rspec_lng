class CreateTableVesselDestination < ActiveRecord::Migration[6.0]
  def change
    create_table :vessel_destinations do |t|
      t.integer :vessel_id
      t.integer :csm_id
      t.string :destination
      t.float :draught
      t.datetime :eta
      t.datetime :last_ais_updated_at, index: true
      t.integer :imo, index: true
      t.timestamps
    end
  end
end
