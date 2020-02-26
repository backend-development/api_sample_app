# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_12_125639) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "money_transactions", force: :cascade do |t|
    t.bigint "creditor_id"
    t.bigint "debitor_id"
    t.string "amount"
    t.string "decimal"
    t.date "paid_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creditor_id"], name: "index_money_transactions_on_creditor_id"
    t.index ["debitor_id"], name: "index_money_transactions_on_debitor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  add_foreign_key "money_transactions", "users", column: "creditor_id"
  add_foreign_key "money_transactions", "users", column: "debitor_id"
end
