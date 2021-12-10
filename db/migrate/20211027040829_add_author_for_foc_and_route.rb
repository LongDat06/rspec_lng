class AddAuthorForFocAndRoute < ActiveRecord::Migration[6.0]
  def change
  	add_column :analytic_focs, :created_by, :integer, index: true, null: false
  	add_column :analytic_focs, :updated_by, :integer, index: true, null: false
  	add_column :analytic_routes, :created_by, :integer, index: true, null: false
  	add_column :analytic_routes, :updated_by, :integer, index: true, null: false
  end
end
