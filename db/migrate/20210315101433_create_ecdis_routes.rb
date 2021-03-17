class CreateEcdisRoutes < ActiveRecord::Migration[6.0]
  def change
    create_table :ecdis_routes do |t|
      t.integer :imo, null: false, index: true
      t.string :format_file, null: false, default: ''
      t.string :file_name, null: false, default: ''
      t.datetime :etd
      t.datetime :eta
      t.float :max_power
      t.float :speed
      t.float :etd_wpno
      t.float :eta_wpno
      t.string :optimized, null: false, default: ''
      t.float :budget
      t.datetime :received_at, null: false

      t.timestamps
    end
  end
end
