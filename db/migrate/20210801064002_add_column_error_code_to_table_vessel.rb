class AddColumnErrorCodeToTableVessel < ActiveRecord::Migration[6.0]
  def change
    add_column :vessels, :error_code, :string, null: false, default: ''
  end
end
