class CreateTableTracking < ActiveRecord::Migration[6.0]
  def change
    create_table :trackings do |t|
      t.float :latitude
      t.float :longitude
      t.integer :heading
      t.float :speed_over_ground
      t.datetime :last_ais_updated_at, index: true
      t.integer :nav_status_code
      t.integer :vessel_id
      t.float :course
      t.integer :collection_type
      t.string :source
      t.boolean :is_valid
      t.boolean :need_to_scan
      t.integer :imo, index: true
      t.timestamps
    end
  end
end
