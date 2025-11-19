class CreatePersonaResponsability < ActiveRecord::Migration[8.0]
  def change
    create_table :persona_responsabilities do |t|
      t.string :contact
      t.string :parent
      t.references :persona, null: false, foreign_key: true

      t.timestamps
    end
  end
end
