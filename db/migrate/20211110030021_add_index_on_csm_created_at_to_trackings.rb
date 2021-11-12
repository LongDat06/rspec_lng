class AddIndexOnCsmCreatedAtToTrackings < ActiveRecord::Migration[6.0]
  def up
    unless index_name_exists?(:trackings, :index_trackings_on_csm_created_at)
      add_index :trackings, :csm_created_at, name: :index_trackings_on_csm_created_at
    end
  end

  def down
    remove_index :trackings, name: :index_trackings_on_csm_created_at
  end
end
