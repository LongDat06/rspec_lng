class CreateTableRole < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false, default: ''
      t.text :activities, array: true, default: []
      t.timestamps
    end
  end
end
