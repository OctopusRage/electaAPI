class VoteOption < ActiveRecord::Base
  belongs_to :vote

  validates :options , presence: true
  
  def as_json(options={})
    {
      id: id,
      options: self.options,
      percentage: vote.count_percentage(id)
    }
  end
end
