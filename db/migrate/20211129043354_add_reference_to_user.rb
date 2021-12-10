class AddReferenceToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :analytic_master_ports, :updated_by, references: :users, index: true
    add_reference :analytic_master_routes, :updated_by, references: :users, index: true
    add_reference :analytic_routes, :updated_by, references: :users, index: true
    add_reference :analytic_focs, :updated_by, references: :users, index: true

    add_reference :analytic_master_ports, :created_by, references: :users, index: true
    add_reference :analytic_master_routes, :created_by, references: :users, index: true
    add_reference :analytic_routes, :created_by, references: :users, index: true
    add_reference :analytic_focs, :created_by, references: :users, index: true

    execute <<-SQL
      UPDATE analytic_routes SET updated_by_id = updated_by, created_by_id = created_by;
      UPDATE analytic_focs SET updated_by_id = updated_by, created_by_id = created_by;
    SQL

  end
end
