class Api::V1::Analyzes::VotesController < ApplicationController
	before_action :authorize_user
	def show
		vote = Vote.find(params[:id])
		if vote
			user_vote =  UserVote.joins(:user).where("user_votes.vote_id  = ?", params[:id])
			options_stats = vote.as_detailed_json
			top_education = user_vote.order("count_all DESC").group(:degree).count.try(:first).try(:first) || ""
			top_profesion = user_vote.order("count_all DESC").group(:job).count.try(:first).try(:first) || ""

			render json: {
				status: 'success',
				data: {
					vote: options_stats,
					global_stats: {
						top_education: top_education,
						top_profesion: top_profesion
					}
				}
			}, status: 200
		else
			render json: {
				status: 'fail',
				data: {
					messages: "error load vote"
				}
			}, status: 422
		end

	end
end
