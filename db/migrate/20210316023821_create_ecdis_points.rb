class CreateEcdisPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :ecdis_points do |t|
      t.references :ecdis_route, null: false, index: true
      t.string :name, null: false, default: ''
      t.float :lat
      t.float :lon
      t.string :leg_type, null: false, default: ''
      t.float :turn_radius
      t.integer :chn_limit
      t.float :planned_speed
      t.float :speed_min
      t.float :speed_max
      t.float :course
      t.float :length
      t.date :do_plan
      t.time :do_left
      t.date :hfo_plan
      t.time :hfo_left
      t.date :eta_day
      t.time :eta_time
      t.datetime :original_eta
      t.timestamps
    end
  end
end
