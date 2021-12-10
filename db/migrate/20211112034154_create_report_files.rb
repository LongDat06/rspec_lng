class CreateReportFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :analytic_report_files do |t|
      t.integer :user_id, index: true
      t.text :file_content_data
      t.string :source

      t.timestamps
    end
  end
end
