class FollowsController < ApplicationController
	before_action :authorize_user
	def create
		follow = UserFollower.new(follows_params)
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
	private
		def follows_params
			params.permit(:following_id, :follower_id)
		end
end