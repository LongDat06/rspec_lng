class AddColumnCsmCreatedAtToTableVesselDestination < ActiveRecord::Migration[6.0]
  def change
    add_column :vessel_destinations, :csm_created_at, :datetime
  end
end
