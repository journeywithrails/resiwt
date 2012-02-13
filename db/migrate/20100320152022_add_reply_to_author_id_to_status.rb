class AddReplyToAuthorIdToStatus < ActiveRecord::Migration
  def self.up
    add_column :statuses, :reply_to_author, :integer
  end

  def self.down
    remove_column :statuses, :reply_to_author
  end
end
