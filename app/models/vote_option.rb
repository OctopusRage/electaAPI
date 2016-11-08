class VoteOption < ActiveRecord::Base
  belongs_to :vote

  has_many :file_uploads, as: :uploader
  validates :options , presence: true
  
  def image
    if file_uploads.count > 0
      file_uploads.last.url
    else
      ""
    end
  end

  def as_json(options={})
    {
      id: id,
      options: self.options,
      percentage: vote.count_percentage(id),
      total_voter: vote.count_option_voter(id),
      image: image
    }
  end
end
