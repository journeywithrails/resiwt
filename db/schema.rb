# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100713210951) do

  create_table "accounts", :force => true do |t|
    t.string   "screen_name"
    t.string   "atoken"
    t.string   "asecret"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email_notifications", :default => "none"
    t.string   "bitly_token"
    t.string   "bitly_secret"
    t.text     "location"
    t.string   "profile_image_url",   :default => "blank.png"
    t.integer  "twitter_id",                                   :null => false
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.boolean  "event_notifications", :default => false
    t.datetime "twitter_created_at"
    t.float    "influence",           :default => 0.0
    t.boolean  "protected",           :default => false
    t.integer  "rate_limit"
    t.integer  "ready_state",         :default => 0
    t.string   "location_hash"
  end

  add_index "accounts", ["screen_name"], :name => "index_accounts_on_screen_name"
  add_index "accounts", ["twitter_created_at"], :name => "index_accounts_on_twitter_created_at"
  add_index "accounts", ["twitter_id"], :name => "index_accounts_on_twitter_id"
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "charts", :force => true do |t|
    t.text     "data"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "charts", ["account_id"], :name => "index_charts_on_account_id"

  create_table "conversations", :force => true do |t|
    t.integer  "account_id"
    t.string   "user_a"
    t.string   "user_b"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversations", ["account_id"], :name => "index_conversations_on_account_id"

  create_table "events", :force => true do |t|
    t.integer  "object_id"
    t.string   "object_type"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "object_created_at"
  end

  add_index "events", ["account_id"], :name => "index_events_on_account_id"
  add_index "events", ["object_id"], :name => "index_events_on_object_id"
  add_index "events", ["object_type"], :name => "index_events_on_object_type"

  create_table "feedback_entries", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedback_entries", ["user_id"], :name => "index_feedback_entries_on_user_id"

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "unique_hash"
    t.string   "user_hash"
    t.string   "long_url"
    t.string   "short_url"
    t.integer  "cached_clickcount",      :default => 0
    t.integer  "account_id"
    t.text     "referrers"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cached_user_clickcount", :default => 0
  end

  add_index "links", ["account_id"], :name => "index_links_on_account_id"

  create_table "poll_answers", :force => true do |t|
    t.integer  "poll_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "poll_answers", ["poll_id"], :name => "index_poll_answers_on_poll_id"

  create_table "poll_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poll_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "poll_entries", ["poll_answer_id"], :name => "index_poll_entries_on_poll_answer_id"
  add_index "poll_entries", ["user_id"], :name => "index_poll_entries_on_user_id"

  create_table "polls", :force => true do |t|
    t.string   "title"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "search_id"
    t.integer  "from_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.boolean  "mutual_follow",   :default => false
    t.integer  "to_account_id"
    t.integer  "statuses_count"
    t.integer  "followers_count"
    t.integer  "friends_count"
    t.datetime "last_synced_at"
  end

  add_index "relationships", ["from_account_id"], :name => "index_relationships_on_from_account_id"
  add_index "relationships", ["search_id"], :name => "index_relationships_on_search_id"
  add_index "relationships", ["to_account_id", "type"], :name => "index_relationships_on_to_account_id_and_type"
  add_index "relationships", ["to_account_id"], :name => "index_relationships_on_to_account_id"
  add_index "relationships", ["type"], :name => "index_relationships_on_type"

  create_table "resque_jobs", :force => true do |t|
    t.string   "record_type"
    t.integer  "record_id"
    t.string   "association"
    t.datetime "refreshed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_running"
    t.integer  "page",         :default => 1
  end

  add_index "resque_jobs", ["association"], :name => "index_resque_jobs_on_association"
  add_index "resque_jobs", ["is_running"], :name => "index_resque_jobs_on_is_running"
  add_index "resque_jobs", ["page"], :name => "index_resque_jobs_on_page"
  add_index "resque_jobs", ["record_id"], :name => "index_resque_jobs_on_record_id"
  add_index "resque_jobs", ["record_type", "record_id", "association", "page"], :name => "job_record_index", :unique => true
  add_index "resque_jobs", ["record_type"], :name => "index_resque_jobs_on_record_type"

  create_table "scheduled_statuses", :force => true do |t|
    t.integer  "account_id"
    t.text     "text",         :limit => 255
    t.datetime "publish_date"
    t.boolean  "published",                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scheduled_statuses", ["account_id"], :name => "index_scheduled_statuses_on_account_id"

  create_table "search_condition_types", :force => true do |t|
    t.string   "operator"
    t.string   "label"
    t.boolean  "value_required", :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "processor"
  end

  create_table "search_conditions", :force => true do |t|
    t.integer  "search_condition_type_id"
    t.integer  "search_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_conditions", ["search_condition_type_id"], :name => "index_search_conditions_on_search_condition_type_id"
  add_index "search_conditions", ["search_id"], :name => "index_search_conditions_on_search_id"

  create_table "searches", :force => true do |t|
    t.string   "title"
    t.integer  "account_id"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["account_id"], :name => "index_searches_on_account_id"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_name_and_sluggable_type_and_scope_and_sequence", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "statuses", :force => true do |t|
    t.integer  "account_id"
    t.integer  "author_id"
    t.integer  "reply_to_id"
    t.integer  "retweet_id"
    t.text     "message"
    t.string   "source",            :default => "web"
    t.boolean  "favourite",         :default => false
    t.string   "coordinates"
    t.string   "twitter_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "retweet_author_id"
    t.integer  "reply_to_author"
    t.boolean  "mentioned",         :default => false
    t.boolean  "is_favourite",      :default => false
    t.datetime "tweeted_at"
    t.boolean  "is_timeline"
    t.integer  "search_id"
  end

  add_index "statuses", ["account_id", "twitter_id"], :name => "index_statuses_on_account_id_and_twitter_id"
  add_index "statuses", ["account_id"], :name => "index_statuses_on_account_id"
  add_index "statuses", ["author_id"], :name => "index_statuses_on_author_id"
  add_index "statuses", ["favourite"], :name => "index_statuses_on_favourite"
  add_index "statuses", ["reply_to_id"], :name => "index_statuses_on_reply_to_id"
  add_index "statuses", ["retweet_author_id"], :name => "index_statuses_on_retweet_author_id"
  add_index "statuses", ["retweet_id"], :name => "index_statuses_on_retweet_id"
  add_index "statuses", ["search_id"], :name => "index_statuses_on_search_id"
  add_index "statuses", ["twitter_id"], :name => "index_statuses_on_twitter_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password", :limit => 128
    t.string   "salt",               :limit => 128
    t.string   "token",              :limit => 128
    t.datetime "token_expires_at"
    t.boolean  "email_confirmed",                   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "feature_level"
    t.integer  "plan_id"
    t.integer  "invitation_id"
    t.integer  "invitation_limit"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "token"], :name => "index_users_on_id_and_token"
  add_index "users", ["token"], :name => "index_users_on_token"

end
