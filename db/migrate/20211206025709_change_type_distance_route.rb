class ChangeTypeDistanceRoute < ActiveRecord::Migration[6.0]
  def change
    change_column :analytic_routes, :distance, :float
  end
end
