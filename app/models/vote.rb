class Vote < ActiveRecord::Base
  VALID_STATUS = %w(open closed draft)

  belongs_to :vote_category
  belongs_to :user
  has_many :vote_options
  
  validate :valid_date_range?
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
    if ended_at < started_at || ended_at < DateTime.now || started_at < DateTime.now 
      errors.add(message: 'invalid date range')
    end
  end

  def as_detailed_json
    category = vote_category.as_simple_json if !vote_category.nil? 
    creator = user.as_simple_json if !user.nil?
    {
      id: id,
      title: title,
      description: description,
      category: category || "Uncategorized",
      started_at: started_at,
      ended_at: ended_at,
      vote_pict_url: vote_pict_url || "",
      creator: creator || nil,
      options: vote_options
    }
  end

  def as_json(options={})
    category = vote_category.as_simple_json if !vote_category.nil? 
    creator = user.as_simple_json if !user.nil?
    {
      id: id,
      title: title,
      description: description,
      category: category || "Uncategorized",
      started_at: started_at,
      ended_at: ended_at,
      vote_pict_url: vote_pict_url || "",
      creator: creator || nil
    }
  end
end
