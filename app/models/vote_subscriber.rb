class VoteSubscriber < ActiveRecord::Base
  belongs_to :vote
  belongs_to :user
end
