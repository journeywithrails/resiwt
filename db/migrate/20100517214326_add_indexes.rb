class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :accounts, :screen_name
    add_index :accounts, :user_id
    add_index :accounts, :twitter_id
    add_index :accounts, :twitter_created_at
    
    add_index :conversations, :account_id
    add_index :charts, :account_id
    
    add_index :events, :object_id
    add_index :events, :object_type
    add_index :events, :account_id
    
    add_index :feedback_entries, :user_id
    add_index :poll_entries, :user_id
    add_index :poll_entries, :poll_answer_id
    
    add_index :links, :account_id
    add_index :poll_answers, :poll_id
    
    add_index :relationships, :search_id
    add_index :relationships, :from_account_id
    add_index :relationships, :to_account_id
    add_index :relationships, :type
    add_index :relationships, :statuses_count
    add_index :relationships, :followers_count
    add_index :relationships, :friends_count
    
    add_index :resque_jobs, :record_id
    add_index :resque_jobs, :record_type
    add_index :resque_jobs, :association
    add_index :resque_jobs, :is_running
    add_index :resque_jobs, :page
    
    add_index :scheduled_statuses, :account_id
    
    add_index :search_conditions, :search_condition_type_id
    add_index :search_conditions, :search_id
    
    add_index :searches, :account_id

    add_index :statuses, :account_id
    add_index :statuses, :author_id
    add_index :statuses, :reply_to_id
    add_index :statuses, :retweet_id
    add_index :statuses, :favourite
    add_index :statuses, :twitter_id
    add_index :statuses, :type
    add_index :statuses, :retweet_author_id
    add_index :statuses, :reply_to_author
    add_index :statuses, :mentioned
    add_index :statuses, :is_favourite
    add_index :statuses, :tweeted_at
    add_index :statuses, :is_timeline
    add_index :statuses, :search_id
  end
  
  def self.down
    remove_index :accounts, :screen_name
    remove_index :accounts, :user_id
    remove_index :accounts, :twitter_id
    remove_index :accounts, :twitter_created_at

    remove_index :conversations, :account_id
    remove_index :charts, :account_id

    remove_index :events, :object_id
    remove_index :events, :object_type
    remove_index :events, :account_id

    remove_index :feedback_entries, :user_id
    remove_index :poll_entries, :user_id
    remove_index :poll_entries, :poll_answer_id

    remove_index :links, :account_id
    remove_index :poll_answers, :poll_id

    remove_index :relationships, :search_id
    remove_index :relationships, :from_account_id
    remove_index :relationships, :to_account_id
    remove_index :relationships, :type
    remove_index :relationships, :statuses_count
    remove_index :relationships, :followers_count
    remove_index :relationships, :friends_count

    remove_index :resque_jobs, :record_id
    remove_index :resque_jobs, :record_type
    remove_index :resque_jobs, :association
    remove_index :resque_jobs, :is_running
    remove_index :resque_jobs, :page

    remove_index :scheduled_statuses, :account_id

    remove_index :search_conditions, :search_condition_type_id
    remove_index :search_conditions, :search_id

    remove_index :searches, :account_id

    remove_index :statuses, :account_id
    remove_index :statuses, :author_id
    remove_index :statuses, :reply_to_id
    remove_index :statuses, :retweet_id
    remove_index :statuses, :favourite
    remove_index :statuses, :twitter_id
    remove_index :statuses, :type
    remove_index :statuses, :retweet_author_id
    remove_index :statuses, :reply_to_author
    remove_index :statuses, :mentioned
    remove_index :statuses, :is_favourite
    remove_index :statuses, :tweeted_at
    remove_index :statuses, :is_timeline
    remove_index :statuses, :search_id
  end
end
