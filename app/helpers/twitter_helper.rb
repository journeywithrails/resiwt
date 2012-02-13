module TwitterHelper
  
  def link_to_twitter_person(text, person, opts={})
    link_to text, "http://twitter.com/#{person}", opts
  end
  
  def link_to_twitter_followers(text, person, opts={})
    link_to text, "http://twitter.com/#{person}/followers", opts
  end
  
  def link_to_twitter_friends(text, person, opts={})
    link_to text, "http://twitter.com/#{person}/following", opts
  end
  
end
