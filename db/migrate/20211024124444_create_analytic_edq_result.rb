class CreateAnalyticEdqResult < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_edq_results do |t|
      t.integer :imo, null: false, index: true
      t.string :name, null: false
      t.float :foe, null: false
      t.float :init_lng_volume, null: false
      t.float :unpumpable, null: false
      t.float :cosuming_lng_of_laden_voyage, null: false
      t.float :heel, null: false
      t.float :edq, null: false
      t.references :laden_voyage, index: true, foreign_key: { to_table: :analytic_heel_results }, null: true
      t.references :ballast_voyage, index: true, foreign_key: { to_table: :analytic_heel_results }, null: true
      t.boolean :published, null: false, default: false
      t.references :author, index: true, foreign_key: { to_table: :users }
      t.references :updated_by, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
