class AddDisplayToGenres < ActiveRecord::Migration[6.0]
  def change
    add_column :analytic_genres, :active, :boolean, default: false
  end
end
