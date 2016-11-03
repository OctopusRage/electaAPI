class Reward < ActiveRecord::Base
  belongs_to :rewarder, polymorphic: true
end
