class ChangeColumnAllowNullEdqInAnalyticEdqResult < ActiveRecord::Migration[6.0]
  def change
    change_column :analytic_edq_results, :init_lng_volume, :float, null: true
    change_column :analytic_edq_results, :unpumpable, :float, null: true
    change_column :analytic_edq_results, :cosuming_lng_of_laden_voyage, :float, null: true
    change_column :analytic_edq_results, :heel, :float, null: true
    change_column :analytic_edq_results, :edq, :float, null: true
  end
end
