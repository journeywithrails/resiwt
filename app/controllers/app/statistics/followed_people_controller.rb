module App
  module Statistics
    class FollowedPeopleController < BaseController

      def index
	     
        @people_count     = @account.followed_people.count
        @people           = @account.followed_people.all :conditions => ['created_at > ?', 2.weeks.ago]        
        @grouped_people   = @people.group_by { |p| p.created_at.beginning_of_day }
        
        respond_to do |wants|
          wants.html
          wants.chart do
            values = []
            
            @grouped_people.each do |day, people|
              values << { :value => people.size, :label => day }
            end
            
            chart = build_line_chart(values, "#val# people", "followed count")
            
            render :text => chart.render
          end
        end
      end

      def destroy
	 @cb_vals=params[:unfollowed]  
	 @values = @cb_vals.to_hash
	 @values.each  do |key, value| 		 
	   if value.to_i == 1
	     user = @account.client.friendship_destroy(key)
	     # make sure we remember not to follow them again through auto follower.
	     @account.ignored_people.build(:user => user).save!
	   end
	 end
	 redirect_to :action => 'index' 
      end	      

      
    end
  end
end
