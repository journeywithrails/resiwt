module App
  module Relationships
    class Unfollowed < Person
      default_scope :order => "updated_at DESC"
      
    end
  end
end
