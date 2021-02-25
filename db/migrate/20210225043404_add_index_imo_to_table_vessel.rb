class AddIndexImoToTableVessel < ActiveRecord::Migration[6.0]
  def change
    add_index :vessels, :imo, unique: true
  end
end
