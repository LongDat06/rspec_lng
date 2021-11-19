class CreateAnalyticHeelResult < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_heel_results do |t|
      t.string :type, null: false
      t.string :port_dept, null: false
      t.string :port_arrival, null: false
      t.string :pacific_route, null: false
      t.datetime :etd, null: false
      t.datetime :eta, null: false
      t.float :estimated_distance, null: false
      t.float :voyage_duration, null: false
      t.float :required_speed, null: false
      t.float :estimated_daily_foc, null: false
      t.float :estimated_daily_foc_season_effect, null: false
      t.float :estimated_total_foc, null: false
      t.float :consuming_lng, null: false
    end
  end
end
