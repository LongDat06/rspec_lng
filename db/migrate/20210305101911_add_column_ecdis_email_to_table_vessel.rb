class AddColumnEcdisEmailToTableVessel < ActiveRecord::Migration[6.0]
  def change
    add_column :vessels, :ecdis_email, :string, null: false, default: ''
  end
end
