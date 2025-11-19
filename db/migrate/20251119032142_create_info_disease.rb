class CreateInfoDisease < ActiveRecord::Migration[8.0]
  def change
    create_table :info_diseases do |t|
      t.date :date_start
      t.date :date_end
      t.string :plan
      t.boolean :family

      t.timestamps
    end
  end
end
