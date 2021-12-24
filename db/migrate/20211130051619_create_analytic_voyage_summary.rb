class CreateAnalyticVoyageSummary < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_voyage_summaries do |t|
      t.integer :imo, null: false
      t.string :voyage_no, null: false
      t.string :voyage_leg, null: false
      t.string :port_dept
      t.datetime :etd_lt
      t.datetime :etd_utc
      t.string :port_arrival
      t.datetime :eta_utc
      t.datetime :eta_lt
      t.integer :duration
      t.integer :distance
      t.float :average_speed
      t.integer :cargo_volume_at_port_of_arrival
      t.float :lng_consumption
      t.float :mgo_consumption
      t.float :average_boil_off_rate
      t.integer :actual_heel
      t.integer :adq
      t.timestamps
    end
    add_index :analytic_voyage_summaries, %i(imo voyage_no voyage_leg), unique: true, name: :analytic_voyage_summaries_uniq_idx
  end
end
