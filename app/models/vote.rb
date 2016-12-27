include ActionView::Helpers::DateHelper
class Vote < ActiveRecord::Base
  VALID_STATUS = %w(open closed draft)
  before_destroy :delete_options
  belongs_to :vote_category
  belongs_to :user
  has_many :vote_options
  has_many :user_votes
  has_many :file_uploads, as: :uploader



  validates :title, presence: true
  validates :user_id, presence:true
  validates :status, inclusion: { in: VALID_STATUS },
    allow_blank: true, case_sensitive: false
  scope :desc, -> {order(created_at: :desc)}
  scope :open, -> {where(status: 'open')}
	scope :closed, -> {where(status: 'closed')}
  scope :draft, -> {where(status: 'draft')}

  def generate_vote_options(options)
		options.each do |option|
			vote_option = self.vote_options.build(options: option)
			vote_option.save
		end
	end

  def valid_date_range?
    return if started_at.blank? && ended_at.blank?
    errors.add(message: 'invalid date range') if started_at.blank? && ended_at.present?
    errors.add(message: 'invalid date range') if ended_at.blank? && started_at.present?
    if ended_at < started_at || ended_at < (DateTime.now - 1.days) || started_at < (DateTime.now - 1.days)
      errors.add(message: 'invalid date range')
    end
  end

  def count_percentage(options_id)
    particpant_count = user_votes.count
    if particpant_count > 0
      current_opt_part_count = user_votes.where(vote_option_id: options_id).count
      '%.2f' % (((current_opt_part_count.to_f)/(particpant_count.to_f))*100)
    else
      0
    end
  end

  def count_option_voter(options_id)
    particpant_count = user_votes.count
    current_opt_part_count = user_votes.where(vote_option_id: options_id).count
    current_opt_part_count
  end

  def delete_options
    user_votes.destroy_all
    vote_options.destroy_all
  end

  def image
    if file_uploads.count > 0
      file_uploads.last.url
    else
      ""
    end
  end

  def as_detailed_json(options={})
    category = vote_category.as_simple_json if !vote_category.nil?
    creator = user.as_simple_json if !user.nil?
    {
      id: id,
      status: status,
      title: title,
      image: image,
      description: description || "",
      category: vote_category.try(:category) || "Uncategorized",
      category_id: vote_category.try(:id) || "",
      started_at: started_at || "",
      ended_at: ended_at || "",
      creator: creator || nil,
      options: vote_options,
      total_participant: user_votes.count || 0,
      created_at: created_at
    }
  end

  def as_json(options={})
    category = vote_category.as_simple_json if !vote_category.nil?
    creator = user.as_simple_json if !user.nil?
    {
      id: id,
      title: title,
      status: status,
      image: image,
      description: description || "",
      category: vote_category.try(:category) || "Uncategorized",
      category_id: vote_category.try(:id) || "",
      started_at: started_at || "",
      ended_at: ended_at || "",
      vote_pict_url: vote_pict_url || "",
      creator: creator || nil,
      total_participant: user_votes.count || 0,
      created_at: created_at
    }
  end
end
