class CreateTableToken < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.text :crypted_token, null: false, default: ''
      t.timestamps
    end
  end
end
