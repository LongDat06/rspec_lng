class CreateVessels < ActiveRecord::Migration[6.0]
  def change
    create_table :vessels do |t|
      t.integer :mmsi
      t.integer :imo
      t.string :name
      t.string :callsign
      t.string :date_of_build
      t.integer :ship_type_id
      t.timestamps
    end
  end
end
