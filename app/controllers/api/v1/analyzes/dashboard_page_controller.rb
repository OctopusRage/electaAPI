class Api::V1::Analyzes::DashboardPage < ApplicationController
	before_action :authorize_user
	def show
		follower_count = UserFollower.where(following_id: current_user.id).count
    following_count = UserFollower.where(follower_id: current_user.id).count
    total_vote = current_user.votes.all.count
    today_participant_count = UserVote.where()
	end
end