class CreateTablePermission < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.references :user, index: true
      t.references :role, index: true
      t.timestamps
    end
  end
end
