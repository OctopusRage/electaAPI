class Api::V1::Votes::ParticipateController < ApplicationController
	before_action :authorize_user
	def create
		vote_id = params[:vote_id].to_i
		choosen_index = params[:choosen_index].to_i 
		user_vote = UserVote.participate(current_user, vote_id, choosen_index)
		if user_vote[:error_message].nil?
			render json:{
				status: 'success', 
				data: user_vote
			}, status: 200
		else
			render json:{
				status: 'fail', 
				data: user_vote
			}, status: 422
		end
	end

	def update
		vote_id = params[:vote_id].to_i
		choosen_index = params[:choosen_index].to_i
		user_vote = UserVote.change(current_user, vote_id, choosen_index)
		if user_vote
			render json:{
				status: 'success',
				data: user_vote
			}, status: 200
		else
			render json:{
				status: 'fail',
				data: user_vote
			}, status: 422
		end
	end
	
end