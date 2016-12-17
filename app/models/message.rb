class Message < ActiveRecord::Base
	def as_json(options={})
		{
			id: id, 
			to: to, 
			to_name: User.find(to).name,
			from: from,
			message: message,
			created_at: created_at
		}
	end	
end
