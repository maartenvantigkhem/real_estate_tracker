# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151105072927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "properties", force: :cascade do |t|
    t.decimal  "monthly_rental_income"
    t.decimal  "down_payment_percent"
    t.decimal  "sale_price"
    t.decimal  "operating_expenses_percent"
    t.decimal  "vacancy_percent"
    t.decimal  "loan_interest_percent"
    t.integer  "loan_length_years"
    t.decimal  "sales_commission_percent"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "posting_url"
    t.integer  "num_years_to_hold"
    t.decimal  "rent_price_increase_percent"
    t.decimal  "tax_rate_percent"
  end

end
