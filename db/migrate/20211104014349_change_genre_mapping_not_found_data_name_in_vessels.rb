class ChangeGenreMappingNotFoundDataNameInVessels < ActiveRecord::Migration[6.0]
  def change
    rename_column :vessels, :genre_mapping_notfound_data, :genre_error_reporting_data
  end
end
