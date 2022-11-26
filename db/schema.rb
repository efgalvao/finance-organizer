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

ActiveRecord::Schema.define(version: 2022_11_25_235055) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_reports", force: :cascade do |t|
    t.datetime "date"
    t.integer "incomes_cents", default: 0, null: false
    t.integer "expenses_cents", default: 0, null: false
    t.integer "invested_cents", default: 0, null: false
    t.integer "final_cents", default: 0, null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "dividends_cents", default: 0, null: false
    t.index ["account_id"], name: "index_account_reports_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "savings"
    t.bigint "user_id", null: false
    t.integer "balance_cents", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "kind", default: 0, null: false
    t.index ["name"], name: "index_accounts_on_name", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "dividends", force: :cascade do |t|
    t.datetime "date"
    t.integer "value_cents", default: 0, null: false
    t.bigint "stock_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_dividends_on_stock_id"
  end

  create_table "negotiations", force: :cascade do |t|
    t.bigint "treasury_id", null: false
    t.integer "kind", default: 0, null: false
    t.datetime "date"
    t.integer "invested_cents", default: 0, null: false
    t.integer "shares", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["treasury_id"], name: "index_negotiations_on_treasury_id"
  end

  create_table "positions", force: :cascade do |t|
    t.bigint "treasury_id", null: false
    t.datetime "date", null: false
    t.integer "amount_cents", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["treasury_id"], name: "index_positions_on_treasury_id"
  end

  create_table "prices", force: :cascade do |t|
    t.datetime "date"
    t.integer "value_cents", default: 0, null: false
    t.bigint "stock_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_prices_on_stock_id"
  end

  create_table "shares", force: :cascade do |t|
    t.datetime "date"
    t.integer "invested_cents", default: 0, null: false
    t.bigint "stock_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "quantity", default: 0, null: false
    t.index ["stock_id"], name: "index_shares_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "ticker", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "invested_value_cents", default: 0, null: false
    t.integer "current_value_cents", default: 0, null: false
    t.integer "current_total_value_cents", default: 0, null: false
    t.integer "shares_total", default: 0
    t.index ["account_id"], name: "index_stocks_on_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "category_id"
    t.integer "value_cents", default: 0, null: false
    t.integer "kind", default: 0, null: false
    t.string "title", null: false
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
  end

  create_table "transferences", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.bigint "user_id"
    t.date "date"
    t.integer "value_cents", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_id"], name: "index_transferences_on_receiver_id"
    t.index ["sender_id"], name: "index_transferences_on_sender_id"
    t.index ["user_id"], name: "index_transferences_on_user_id"
  end

  create_table "treasuries", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "account_id", null: false
    t.integer "invested_value_cents", default: 0, null: false
    t.integer "current_value_cents", default: 0, null: false
    t.integer "shares", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "released_value_cents", default: 0, null: false
    t.datetime "released_at"
    t.index ["account_id"], name: "index_treasuries_on_account_id"
  end

  create_table "user_reports", force: :cascade do |t|
    t.datetime "date"
    t.integer "savings_cents", default: 0, null: false
    t.integer "stocks_cents", default: 0, null: false
    t.integer "total_cents", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "incomes_cents", default: 0, null: false
    t.integer "expenses_cents", default: 0, null: false
    t.integer "invested_cents", default: 0, null: false
    t.integer "final_cents", default: 0, null: false
    t.integer "card_expenses_cents", default: 0, null: false
    t.integer "dividends_cents", default: 0, null: false
    t.index ["user_id"], name: "index_user_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "account_reports", "accounts"
  add_foreign_key "accounts", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "dividends", "stocks"
  add_foreign_key "negotiations", "treasuries"
  add_foreign_key "positions", "treasuries"
  add_foreign_key "prices", "stocks"
  add_foreign_key "shares", "stocks"
  add_foreign_key "stocks", "accounts"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transferences", "users"
  add_foreign_key "treasuries", "accounts"
  add_foreign_key "user_reports", "users"
end
