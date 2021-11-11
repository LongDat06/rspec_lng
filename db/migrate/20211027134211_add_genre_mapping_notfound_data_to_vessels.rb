class AddGenreMappingNotfoundDataToVessels < ActiveRecord::Migration[6.0]
  def change
    add_column :vessels, :genre_mapping_notfound_data, :text
  end
end
