class AddSomeFieldsToVoyageSummary < ActiveRecord::Migration[6.0]
  def change
    add_column :analytic_voyage_summaries, :pacific_voyage, :boolean, default: false
  end
end
