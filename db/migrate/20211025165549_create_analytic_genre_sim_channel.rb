class CreateAnalyticGenreSimChannel < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_genre_sim_channels do |t|
      t.references :analytic_genres, index: true, null: false
      t.string :iso_std_name
    end

    add_index :analytic_genre_sim_channels, [:analytic_genres_id, :iso_std_name], unique: true, name: :analytic_genre_sim_channels_uniq_idx
  end
end
