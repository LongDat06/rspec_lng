class CreateTableUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ''
      t.string :fullname, null: false, default: ''
      t.integer :role
      t.string :password_digest, null: false, default: ''
      t.timestamps
    end
  end
end
