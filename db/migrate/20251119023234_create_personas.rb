class CreatePersonas < ActiveRecord::Migration[8.0]
  def change
    create_table :personas do |t|
      t.string :name
      t.integer :age
      t.string :occupation
      t.integer :rg
      t.string :organ_sender
      t.integer :cpf
      t.date :birthdate

      t.timestamps
    end
  end
end
