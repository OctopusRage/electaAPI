class VoteCategory < ActiveRecord::Base
  has_many :votes
  def as_simple_json
    {
      id: id,
      category: category
    }
  end
end
