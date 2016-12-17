class Message < ActiveRecord::Base
	validates :to, presence: true
	validates :from, presence: true
	validates :subject, presence: true
	validates :message, presence: true
	def as_json(options={})
		to_name = User.find_by(id: to.to_i).try(:name)
		to_email = User.find_by(id: to.to_i).try(:email)
		from_name = User.find_by(id: from.to_i).try(:name)
		from_email = User.find_by(id: from.to_i).try(:email)
		{
			id: id,
			to: to,
			to_name: to_name,
			to_email: to_email,
			from: from,
			from_name: to_name,
			from_email: to_email,
			subject: subject,
			message: message,
			created_at: created_at
		}
	end
end
