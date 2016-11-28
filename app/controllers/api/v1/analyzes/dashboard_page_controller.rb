class Api::V1::Analyzes::DashboardPage < ApplicationController
	before_action :authorize_user
	def show
		follower_count = UserFollower.where(following_id: current_user.id).count
    following_count = UserFollower.where(follower_id: current_user.id).count
    total_vote = current_user.votes.all.count
    today_participant_count = Vote.select("user_votes.*").joins(:user_votes).where(user_id: current_user.id).count
		render json: {
			follower_count: follower_count,
			following_count: following_count,
			total_vote: total_vote,
			today_participant_count: today_participant_count
		}    
	end
end