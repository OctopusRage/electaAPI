class Api::V1::Users::FollowsController < ApplicationController
	before_action :authorize_user
	def create
		follow = UserFollower.new(follower_id: current_user.id, following_id: params[:id])
		if follow.save 
			render json: {
				status: 'success',
				data:follow
			}
		else
			render json: {
				status: 'fail',
				data: {
					message: follow.errors
				}
			}
		end
	end
end