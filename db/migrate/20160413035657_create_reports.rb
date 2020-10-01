class CreateReports < ActiveRecord::Migration[4.2]
  def change
    create_table :reports do |t|
      t.text :report
      t.boolean :compare

      t.timestamps null: false
    end
  end
end
