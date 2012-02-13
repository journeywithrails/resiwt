class AddInvitiationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invitation_id, :integer
    add_column :users, :invitation_limit, :integer
    #set invitation limit
    User.update_all({:invitation_limit => 5})
  end

  def self.down
    remove_column :users, :invitation_limit
    remove_column :users, :invitation_id
  end
end
