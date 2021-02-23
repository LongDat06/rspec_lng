class AddColumnTargetVesselToTableVessel < ActiveRecord::Migration[6.0]
  def change
    add_column :vessels, :target, :boolean, default: false
    remove_column :vessels, :name
    remove_column :vessels, :mmsi
    remove_column :vessels, :callsign
    remove_column :vessels, :date_of_build
    remove_column :vessels, :ship_type_id
  end
end
