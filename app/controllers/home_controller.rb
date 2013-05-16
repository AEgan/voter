class HomeController < ApplicationController
	
	def index
		@contest = Contest.random.first
		if Competitor.for_contest(@contest.id).count >= 2
			records = Competitor.for_contest(@contest.id).random
			@competitor1 = records[0]
			@competitor2 = records[1]
		end
	end

	def search
		@query = params[:query]
		@competitors = Competitor.search(@query).paginate(:page => params[:competitorsPage]).per_page(10)
		@contests = Contest.search(@query).paginate(:page => params[:contestsPage]).per_page(10)
		if(current_user && current_user.admin?)
			@users = User.search(@query).paginate(:page => params[:usersPage]).per_page(10)
			@count = @contests.count + @competitors.count + @users.count
		end
		@count = @contests.count + @competitors.count 
	end

	def vote
		winner = Competitor.find(params[:winner_id]) unless params[:winner_id].nil?
		loser = Competitor.find(params[:loser_id]) unless params[:loser_id].nil?
		# new version of update_elo method is called on the winner, passing in loser
		winner.update_elo(loser)
		redirect_to home_path
	end
end
