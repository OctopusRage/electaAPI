class Message < ActiveRecord::Base
	def as_json(options={})
		to_name = User.find_by(id: to.to_i).name
		to_email = User.find_by(id: to.to_i).email
		from_name = User.find_by(id: from.to_i).name
		from_email = User.find_by(id: from.to_i).email
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
