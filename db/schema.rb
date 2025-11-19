# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_19_032142) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "genders", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "info_diseases", force: :cascade do |t|
    t.date "date_start"
    t.date "date_end"
    t.string "plan"
    t.boolean "family"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "info_doctors", force: :cascade do |t|
    t.boolean "allergy"
    t.string "chronic"
    t.string "medication_use"
    t.string "surgeries"
    t.date "surgeries_date"
    t.boolean "family_history"
    t.string "history"
    t.boolean "alcohol_use"
    t.string "energy_contact"
    t.string "name_contact"
    t.string "cellphone"
    t.string "parent"
    t.bigint "persona_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id"], name: "index_info_doctors_on_persona_id"
  end

  create_table "level_educations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nationalities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "origins", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "persona_addresses", force: :cascade do |t|
    t.string "nationality"
    t.string "origin"
    t.string "address"
    t.integer "number"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.integer "cep"
    t.bigint "persona_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id"], name: "index_persona_addresses_on_persona_id"
  end

  create_table "persona_responsabilities", force: :cascade do |t|
    t.string "contact"
    t.string "parent"
    t.bigint "persona_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id"], name: "index_persona_responsabilities_on_persona_id"
  end

  create_table "personas", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "occupation"
    t.integer "rg"
    t.string "organ_sender"
    t.integer "cpf"
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gender_id", null: false
    t.bigint "level_education_id", null: false
    t.index ["gender_id"], name: "index_personas_on_gender_id"
    t.index ["level_education_id"], name: "index_personas_on_level_education_id"
  end

  add_foreign_key "info_doctors", "personas"
  add_foreign_key "persona_addresses", "personas"
  add_foreign_key "persona_responsabilities", "personas"
  add_foreign_key "personas", "genders"
  add_foreign_key "personas", "level_educations"
end
