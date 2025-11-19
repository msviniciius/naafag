class CreateInfoDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :info_doctors do |t|
      t.boolean :allergy
      t.string :chronic
      t.string :medication_use
      t.string :surgeries
      t.date :surgeries_date
      t.boolean :family_history
      t.string :history
      t.boolean :alcohol_use
      t.string :energy_contact
      t.string :name_contact
      t.string :cellphone
      t.string :parent
      t.references :persona, null: false, foreign_key: true

      t.timestamps
    end
  end
end
