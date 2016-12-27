class Api::V1::Analyzes::OverviewsController < ApplicationController
	before_action :authorize_user
	def show
		vote = Vote.find(params[:id])
		if vote 
			filter = params[:filter]

			case filter
			when "degree"
				query = "degree"
			when "job"
				query = "job"
			when "city"
				query = "city"
			else
				query = "gender"
			end
			user_vote_cat =  UserVote.joins(:user).where("user_votes.vote_id  = ?", params[:id])
			filtered = user_vote_cat.group(query).count
			render json: {
				status: 'success',
				data: filtered
			}, status: 200
		else
			render json: {
				status: 'fail',
				message: 'fail to load message'
			}, status: 422
		end
	end
end