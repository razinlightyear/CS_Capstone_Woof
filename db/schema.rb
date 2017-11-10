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

ActiveRecord::Schema.define(version: 20171030022847) do

  create_table "breeds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colors_found_dog_delegates", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "found_dog_delegate_id"
    t.integer "color_id"
    t.index ["color_id"], name: "index_colors_found_dog_delegates_on_color_id", using: :btree
    t.index ["found_dog_delegate_id"], name: "index_colors_found_dog_delegates_on_found_dog_delegate_id", using: :btree
  end

  create_table "colors_pets", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "pet_id"
    t.integer "color_id"
    t.index ["color_id"], name: "index_colors_pets_on_color_id", using: :btree
    t.index ["pet_id"], name: "index_colors_pets_on_pet_id", using: :btree
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "device_token"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_devices_on_user_id", using: :btree
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "pet_id"
    t.string   "type",                                                   null: false
    t.boolean  "is_around_me",                           default: false, null: false
    t.decimal  "longitude",    precision: 15, scale: 12
    t.decimal  "latitude",     precision: 15, scale: 12
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "address"
    t.index ["pet_id"], name: "index_events_on_pet_id", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "feeding_history_delegates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "feeding_history_id"
    t.float   "amount",             limit: 24
    t.string  "food_item"
    t.index ["feeding_history_id"], name: "index_feeding_history_delegates_on_feeding_history_id", using: :btree
  end

  create_table "found_dog_delegates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "found_dog_id"
    t.integer "breed_id",                   null: false
    t.integer "weight_id",                  null: false
    t.text    "description",  limit: 65535
    t.index ["breed_id"], name: "index_found_dog_delegates_on_breed_id", using: :btree
    t.index ["found_dog_id"], name: "index_found_dog_delegates_on_found_dog_id", using: :btree
    t.index ["weight_id"], name: "index_found_dog_delegates_on_weight_id", using: :btree
  end

  create_table "group_invites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "group_id"
    t.integer  "inviter_id",   null: false
    t.integer  "invitee_id",   null: false
    t.datetime "accepted_at"
    t.datetime "declined_at"
    t.string   "invite_token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["group_id"], name: "index_group_invites_on_group_id", using: :btree
    t.index ["invite_token"], name: "index_group_invites_on_invite_token", unique: true, using: :btree
    t.index ["invitee_id"], name: "fk_rails_3db2c34e19", using: :btree
    t.index ["inviter_id"], name: "fk_rails_5fc70f3db0", using: :btree
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "owner_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "fk_rails_5447bdb9c5", using: :btree
  end

  create_table "groups_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.index ["group_id"], name: "index_groups_users_on_group_id", using: :btree
    t.index ["user_id"], name: "index_groups_users_on_user_id", using: :btree
  end

  create_table "lost_dog_delegates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text    "description", limit: 65535
    t.integer "lost_dog_id"
    t.index ["lost_dog_id"], name: "index_lost_dog_delegates_on_lost_dog_id", using: :btree
  end

  create_table "nudges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nudge_token"
    t.integer  "user_id"
    t.integer  "response"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "group_id"
    t.integer  "pet_id"
    t.index ["group_id"], name: "index_nudges_on_group_id", using: :btree
    t.index ["pet_id"], name: "index_nudges_on_pet_id", using: :btree
    t.index ["user_id"], name: "index_nudges_on_user_id", using: :btree
  end

  create_table "pets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "breed_id",                   null: false
    t.integer  "weight_id",                  null: false
    t.string   "chip_number"
    t.boolean  "active",      default: true, null: false
    t.string   "image"
    t.index ["breed_id"], name: "index_pets_on_breed_id", using: :btree
    t.index ["group_id"], name: "index_pets_on_group_id", using: :btree
    t.index ["weight_id"], name: "index_pets_on_weight_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "encrypted_password",                default: ""
    t.string   "email",                                             null: false
    t.datetime "remember_created_at"
    t.string   "authentication_token",   limit: 30
    t.boolean  "active",                            default: true,  null: false
    t.boolean  "private",                           default: false, null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",                 default: 0
    t.string   "image"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  end

  create_table "walking_partner_delegates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "walking_partner_id"
    t.text    "description",        limit: 65535
    t.index ["walking_partner_id"], name: "index_walking_partner_delegates_on_walking_partner_id", using: :btree
  end

  create_table "weights", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "start_weight"
    t.integer  "end_weight"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_foreign_key "colors_found_dog_delegates", "colors"
  add_foreign_key "colors_found_dog_delegates", "found_dog_delegates"
  add_foreign_key "colors_pets", "colors"
  add_foreign_key "colors_pets", "pets"
  add_foreign_key "devices", "users"
  add_foreign_key "events", "pets"
  add_foreign_key "events", "users"
  add_foreign_key "found_dog_delegates", "breeds"
  add_foreign_key "found_dog_delegates", "weights"
  add_foreign_key "group_invites", "groups"
  add_foreign_key "group_invites", "users", column: "invitee_id"
  add_foreign_key "group_invites", "users", column: "inviter_id"
  add_foreign_key "groups", "users", column: "owner_id"
  add_foreign_key "groups_users", "groups"
  add_foreign_key "groups_users", "users"
  add_foreign_key "nudges", "groups"
  add_foreign_key "nudges", "pets"
  add_foreign_key "nudges", "users"
  add_foreign_key "pets", "breeds"
  add_foreign_key "pets", "groups"
  add_foreign_key "pets", "weights"
end
