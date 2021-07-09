class ChangeColumnCollectionTypeTotabletracking < ActiveRecord::Migration[6.0]
  def change
    remove_column :trackings, :collection_type
    add_column :trackings, :collection_type, :string, null: false, default: ''
  end
end
