class CreateAnalyticFocs < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_focs do |t|
      t.integer :imo
      t.float :speed
      t.float :laden
      t.float :ballast
      t.integer :created_by, index: true
      t.integer :updated_by, index: true
      t.timestamps
    end
    add_index :analytic_focs, [:imo, :speed], unique: true
    add_index :analytic_focs, :imo
  end
end
