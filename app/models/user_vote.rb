class UserVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :vote_option
  belongs_to :vote

  validates :vote_id, presence:true
  validates :vote_option_id, presence: true
  validates :user_id, uniqueness: { scope: :vote_id }, presence: true
  validate :validate_options

  def validate_options
    if self.vote_option_id    
      vote = Vote.find(self.vote_id).vote_options
      if (vote = vote.where(id: self.vote_option_id).exists?) == false
        self.errors["vote options"] << "vote option doesnt belongs to this vote"
      end
    end
  end

  def self.participate(current_user, vote_id, choice)
  	return {error_message: 'user already voted'} if self.find_by(user_id:current_user.id, vote_id:vote_id).present?
  	current_vote = Vote.find(vote_id)
  	if current_vote 
  		choosen_option = current_vote.vote_options[choice]
  		if choosen_option.present?
  			commit = current_user.user_votes.create(vote_id: vote_id, vote_option_id: choosen_option.id)
  		else
  			{error_message: 'invalid offset index'}
  		end
  	else
  		{error_message: 'cannot find vote'}
  	end
  end

  def self.change(current_user, vote_id, choice)
  	current_vote = UserVote.find_by(vote_id:vote_id, user_id:current_user.id)
  	if current_vote 
  		choosen_option = current_vote.vote.vote_options[choice]
  		if choosen_option.present?
  			commit = current_vote.update(vote_option_id: choosen_option.id)
  			current_vote
  		else
  			{error_message: 'invalid offset index'}
  		end
  	else
  		{error_message: 'cannot find vote'}
  	end
  end


  def as_json(options={})
		{
			id: id,
			user_id: user_id,
			vote_id: vote_id,
			vote_option_id: vote_option_id
		}
	end

end
