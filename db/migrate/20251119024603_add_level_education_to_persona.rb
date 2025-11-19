class AddLevelEducationToPersona < ActiveRecord::Migration[8.0]
  def change
    add_reference :personas, :level_education, null: false, foreign_key: true
  end
end
