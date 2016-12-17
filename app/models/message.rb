class Message < ActiveRecord::Base
	def as_json(options={})
		{
			id: id,
			to: User.find(to).name,
			from: User.find(from).name, 
			subject: subject, 
			message: message,
			created_at: created_at,
			updated_at: updated_at
		}
	end	
end
