class AddColumnLastPortDepartureAt < ActiveRecord::Migration[6.0]
  def change
    add_column :vessels, :last_port_departure_at, :datetime
  end
end
