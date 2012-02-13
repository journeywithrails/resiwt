# ----------------------------------------------------
# Polls
# ----------------------------------------------------

module Feedback

  p = Poll.create(:title => "Which is your favourite feature of Tweasier?")
  p.answers.build(:title => "Statistics").save
  p.answers.build(:title => "Scheduled tweets").save
  p.answers.build(:title => "Friends and follower sorting").save
  p.answers.build(:title => "Other").save
  
  p = Poll.create(:title => "Which do you think would be the best price bracket for tweasier?")
  p.answers.build(:title => "£9.99").save
  p.answers.build(:title => "£14.99").save
  p.answers.build(:title => "£19.99").save
  p.answers.build(:title => "Other").save
  
  p = Poll.create(:title => "How many followers does your twitter account have?")
  p.answers.build(:title => "Under 1,000").save
  p.answers.build(:title => "Under 3,000").save
  p.answers.build(:title => "Under 5,000").save
  p.answers.build(:title => "Under 10,000").save
  
  p = Poll.create(:title => "What could we improve on Tweasier?")
  p.answers.build(:title => "The speed of the site").save
  p.answers.build(:title => "The design of the features").save
  p.answers.build(:title => "More varied content on the blog").save
  p.answers.build(:title => "More answers in the FAQ").save
  
  p = Poll.create(:title => "How much do you like the Tweasier application?")
  p.answers.build(:title => "It's the best twitter app I have used").save
  p.answers.build(:title => "It's pretty good").save
  p.answers.build(:title => "It's good but I am not that impressed").save
  p.answers.build(:title => "I won't be using Tweasier again").save

end

# ----------------------------------------------------
# Rule Conditions
# ----------------------------------------------------

module App
  
  SearchConditionType.create(:label => "contains", :operator => "")
  SearchConditionType.create(:label => "does not contain", :operator => "-")
  SearchConditionType.create(:label => "to", :operator => "to:")
  SearchConditionType.create(:label => "from", :operator => "from:")
  SearchConditionType.create(:label => "referencing", :operator => "@")
  SearchConditionType.create(:label => "happy", :operator => ":)", :value_required => false)
  SearchConditionType.create(:label => "not happy", :operator => ":(", :value_required => false)
  SearchConditionType.create(:label => "links only", :operator => "filter:links", :value_required => false)
  SearchConditionType.create(:label => "source only", :operator => "source:")
  SearchConditionType.create(:label => "near", :operator => "geocode:", :processor => "geocode")
  
end

puts "** Seeded database"
