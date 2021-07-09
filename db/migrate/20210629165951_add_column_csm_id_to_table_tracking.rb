class AddColumnCsmIdToTableTracking < ActiveRecord::Migration[6.0]
  def change
    add_column :trackings, :csm_id, :bigint
  end
end
