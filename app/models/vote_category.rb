class VoteCategory < ActiveRecord::Base
  has_many :votes
  validates :category, presence: true
  def as_simple_json
    {
      id: id,
      category: category
    }
  end
end
