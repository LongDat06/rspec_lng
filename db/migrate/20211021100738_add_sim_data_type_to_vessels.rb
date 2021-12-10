class AddSimDataTypeToVessels < ActiveRecord::Migration[6.0]
  def change
  	add_column :vessels, :sim_data_type, :string
  end
end
