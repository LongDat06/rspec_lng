class AddColumnEngineTypeToTableVessel < ActiveRecord::Migration[6.0]
  def change
    add_column :vessels, :engine_type, :string, null: false, default: ''
  end
end
