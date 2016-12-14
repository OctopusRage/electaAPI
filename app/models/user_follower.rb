class UserFollower < ActiveRecord::Base
	validates :follower_id, uniqueness: { scope: :following_id }
end
