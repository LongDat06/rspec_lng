class AddColumnVesselNameToTableVessel < ActiveRecord::Migration[6.0]
  def change
    add_column :vessels, :name, :string, null: false, default: ''
  end
end
