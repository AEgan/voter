class HomeController < ApplicationController
	
	def index
		if Competitor.all.count >= 2
			records = Competitor.random
			@competitor1 = records[0]
			@competitor2 = records[1]
		end
	end

	def search
		@query = params[:query]
		@results = Competitor.search(@query)
		@count = @results.count
	end

	def vote
		winner = Competitor.find(params[:winner_id]) unless params[:winner_id].nil?
		loser = Competitor.find(params[:loser_id]) unless params[:loser_id].nil?
		# just realized the way I am doing this doesn't need to bool as a param
		# but I don't want to switch up every call to this just yet
		winner.update_elo(loser, true)
		redirect_to home_path
	end
end
