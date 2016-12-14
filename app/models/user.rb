class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  VALID_GENDER = %w(male female)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  DEFAULT_DATE_OF_BIRTH = "1970-01-01T07:00:00Z"
  DEFAULT_ORIGIN_LAT  = -6.177
  DEFAULT_ORIGIN_LNG  = 106.8403
  AVAILABLE_DEGREE = [
    "SD","SMP","SMA","S1","S2","S3"
  ]  
  AVAILABLE_JOB = [
    "pns", "karyawan"
  ]  

  before_create :set_auth_token, :set_lower_email, :set_lower_job
  
  validates :name, presence: true
  validates :gender, inclusion: { in: VALID_GENDER },
    allow_blank: true, case_sensitive: false
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
 
  

  belongs_to :user_type
  has_many :file_uploads, as: :uploader
  has_many :user_follower, foreign_key: :follower_id, class_name: "UserFollower"
  has_many :votes  
  has_many :user_votes  
  has_many :messages, foreign_key: "to", class_name: "Message"

  def set_lower_email
    self.email = self.email.downcase
  end

  def set_lower_job
    if self.job.present?
      self.job = self.job.downcase
    end
  end
    
  def image(base_url=nil)
    base_url = ENV["AVATAR_BASE_URL"]
    url = "#{base_url}#{avatar_url}" if avatar_url
    url || ""
  end

  def set_auth_token
    self.authentication_token = loop do
      token = SecureRandom.urlsafe_base64(30)
      break token unless self.class.exists?(authentication_token: token)
    end unless authentication_token
  end

  def dob
    (date_of_birth.present?)? (date_of_birth+0.hours).iso8601 : DEFAULT_DATE_OF_BIRTH
  end

  def age(dob)
    now = Time.now.utc.to_date
    if dob
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end
  end

  def as_simple_json(options={})
    {
      id: id, 
      name: name,
      image: image
    }
  end

  def credential_as_json(options={})
    dob = (date_of_birth.present?)? (date_of_birth+0.hours).iso8601 : DEFAULT_DATE_OF_BIRTH
    {
      id: id,
      name: name,
      email: email,
      gender: gender,
      age: age(date_of_birth) || 0,
      date_of_birth: dob,
      phone_number: phone_number ||"",
      verified: verified,
      city: city ||"",
      province: province ||"",
      latitude: latitude || DEFAULT_ORIGIN_LAT,
      longitude: longitude ||DEFAULT_ORIGIN_LNG,
      image: image(options[:base_url]),
      authentication_token: authentication_token
    }
  end

  def as_profile_json(options={})
    {
      id: id,
      name: name,
      gender: gender,
      age: age(date_of_birth) || 0,
      image: image(options[:base_url]),
      city: city, 
      province: province ||""
    }
  end

  def as_json(options={})
    dob = (date_of_birth.present?)? (date_of_birth+0.hours).iso8601 : DEFAULT_DATE_OF_BIRTH
    {
      id: id,
      name: name,
      email: email,
      gender: gender,
      age: age(date_of_birth) || 0,
      date_of_birth: dob,
      phone_number: phone_number ||"",
      verified: verified,
      city: city ||"",
      province: province ||"",
      latitude: latitude || DEFAULT_ORIGIN_LAT,
      longitude: longitude ||DEFAULT_ORIGIN_LNG,
      image: image(options[:base_url])
    }
  end

end
