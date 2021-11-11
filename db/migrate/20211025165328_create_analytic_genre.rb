class CreateAnalyticGenre < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_genres do |t|
      t.integer :imo, null: false, index: true
      t.string :name, null: false
    end

    add_index :analytic_genres, [:imo, :name], unique: true, name: :analytic_genres_uniq_idx
  end
end
