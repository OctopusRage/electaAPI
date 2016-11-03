class UserVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :vote_option
  belongs_to :vote
end
