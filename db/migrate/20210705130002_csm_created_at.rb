class CsmCreatedAt < ActiveRecord::Migration[6.0]
  def change
    add_column :trackings, :csm_created_at, :datetime
  end
end
