class Message < ActiveRecord::Base
	def as_json(options={})
		{
			id: id, 
			to: to, 
			from: from,
			message: message,
			created_at: created_at
		}
	end	
end
