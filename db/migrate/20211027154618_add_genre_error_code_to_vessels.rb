class AddGenreErrorCodeToVessels < ActiveRecord::Migration[6.0]
  def change
    add_column :vessels, :genre_error_code, :string
  end
end
