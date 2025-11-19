class CreateLevelEducation < ActiveRecord::Migration[8.0]
  def change
    create_table :level_educations do |t|
      t.string :name

      t.timestamps
    end
  end
end
