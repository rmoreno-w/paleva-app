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

ActiveRecord::Schema[7.2].define(version: 2024_11_21_054345) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "beverages", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "calories"
    t.boolean "is_alcoholic"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.index ["restaurant_id"], name: "index_beverages_on_restaurant_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.string "name"
    t.decimal "percentage", precision: 10, scale: 2
    t.date "start_date"
    t.date "end_date"
    t.integer "limit_of_uses"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_discounts_on_restaurant_id"
  end

  create_table "dish_tags", force: :cascade do |t|
    t.integer "dish_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_dish_tags_on_dish_id"
    t.index ["tag_id"], name: "index_dish_tags_on_tag_id"
  end

  create_table "dishes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "calories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restaurant_id", null: false
    t.integer "status", default: 1
    t.index ["restaurant_id"], name: "index_dishes_on_restaurant_id"
  end

  create_table "item_option_entries", force: :cascade do |t|
    t.string "itemable_type"
    t.integer "itemable_id"
    t.integer "item_option_set_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_option_set_id"], name: "index_item_option_entries_on_item_option_set_id"
    t.index ["itemable_type", "itemable_id"], name: "index_item_option_entries_on_itemable"
  end

  create_table "item_option_sets", force: :cascade do |t|
    t.string "name"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
    t.index ["restaurant_id"], name: "index_item_option_sets_on_restaurant_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.string "item_name"
    t.string "serving_description"
    t.decimal "serving_price"
    t.integer "number_of_servings"
    t.text "customer_notes"
    t.integer "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "order_status_change_annotations", force: :cascade do |t|
    t.integer "order_status_change_id", null: false
    t.string "annotation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_status_change_id"], name: "idx_on_order_status_change_id_0dc162dcc8"
  end

  create_table "order_status_changes", force: :cascade do |t|
    t.integer "order_id", null: false
    t.string "status"
    t.datetime "change_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_status_changes_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "customer_name"
    t.string "customer_phone"
    t.string "customer_email"
    t.string "customer_registration_number"
    t.integer "status", default: 1
    t.string "code"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
  end

  create_table "pre_registrations", force: :cascade do |t|
    t.string "email"
    t.string "registration_number"
    t.integer "status"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_pre_registrations_on_restaurant_id"
  end

  create_table "price_records", force: :cascade do |t|
    t.decimal "price"
    t.datetime "change_date"
    t.integer "serving_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serving_id"], name: "index_price_records_on_serving_id"
  end

  create_table "restaurant_operating_hours", force: :cascade do |t|
    t.time "start_time"
    t.time "end_time"
    t.integer "status"
    t.integer "weekday"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_restaurant_operating_hours_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "brand_name"
    t.string "corporate_name"
    t.string "registration_number"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.string "code"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_restaurants_on_user_id"
  end

  create_table "servings", force: :cascade do |t|
    t.decimal "current_price"
    t.string "description"
    t.string "servingable_type"
    t.integer "servingable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["servingable_type", "servingable_id"], name: "index_servings_on_servingable"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_tags_on_restaurant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "family_name"
    t.string "registration_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 1
    t.integer "restaurant_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["restaurant_id"], name: "index_users_on_restaurant_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "beverages", "restaurants"
  add_foreign_key "discounts", "restaurants"
  add_foreign_key "dish_tags", "dishes"
  add_foreign_key "dish_tags", "tags"
  add_foreign_key "dishes", "restaurants"
  add_foreign_key "item_option_entries", "item_option_sets"
  add_foreign_key "item_option_sets", "restaurants"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_status_change_annotations", "order_status_changes"
  add_foreign_key "order_status_changes", "orders"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "pre_registrations", "restaurants"
  add_foreign_key "price_records", "servings"
  add_foreign_key "restaurant_operating_hours", "restaurants"
  add_foreign_key "restaurants", "users"
  add_foreign_key "tags", "restaurants"
  add_foreign_key "users", "restaurants"
end
