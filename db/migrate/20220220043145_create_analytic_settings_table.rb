class CreateAnalyticSettingsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_settings do |t|
      t.string :code, null: false, index: { unique: true }
      t.string :value
    end
  end
end
