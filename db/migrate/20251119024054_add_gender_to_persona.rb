class AddGenderToPersona < ActiveRecord::Migration[8.0]
  def change
    add_reference :personas, :gender, null: false, foreign_key: true
  end
end
