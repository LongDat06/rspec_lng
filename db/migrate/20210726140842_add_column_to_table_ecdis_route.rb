class AddColumnToTableEcdisRoute < ActiveRecord::Migration[6.0]
  def change
    add_column :ecdis_routes, :imported_checksum, :string, null: false, default: ''
  end
end
