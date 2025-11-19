class CreatePersonaAddress < ActiveRecord::Migration[8.0]
  def change
    create_table :persona_addresses do |t|
      t.string :nationality
      t.string :origin
      t.string :address
      t.integer :number
      t.string :neighborhood
      t.string :city
      t.string :state
      t.integer :cep
      t.references :persona, null: false, foreign_key: true

      t.timestamps
    end
  end
end
