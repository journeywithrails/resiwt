module App
  class Friendship < ActiveRecord::Base
    belongs_to :from_account, :class_name => 'App::Account'
    belongs_to :to_account, :class_name => 'App::Account'
  end
end