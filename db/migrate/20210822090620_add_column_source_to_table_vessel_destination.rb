class AddColumnSourceToTableVesselDestination < ActiveRecord::Migration[6.0]
  def change
    add_column :vessel_destinations, :source, :string, null: false, default: 'spire'
  end
end
