class Api::V1::Analyzes::VoteOptionsController < ApplicationController
	before_action :authorize_user
	def show
		vote_opt = VoteOption.find(params[:id])
		if vote_opt
			id = params[:id]
			user_vote = UserVote.joins(:user).where(vote_option_id: id)
			vote_id = vote_opt.vote_id
			vote_opt = vote_opt.as_json
			vote_option_title = vote_opt[:options]
			ratio = vote_opt[:percentage]
			total_voter = user_vote.count
			top_education = user_vote.order("count_all DESC ").group(:degree).count.try(:first).try(:first) || ""
			top_profesion = user_vote.order("count_all DESC ").group(:job).count.try(:first).try(:first) || ""
			top_region = user_vote.order("count_all DESC ").group(:city).count.try(:first).try(:first)  || ""
			render json: {
				status: 'success',
				data: {
					vote_option_id: id,
					vote_option_title: vote_option_title,
					total_voter: total_voter,
					ratio: ratio,
					top_education: top_education,
					top_profesion: top_profesion,
					top_region: top_region
				}
			}, status: 200
		else
			render json: {
				status: 'fail',
				data: {
					message: 'Vote options not found'
				}
			}, status: 422
		end
	end
end