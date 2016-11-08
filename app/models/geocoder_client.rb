class GeocoderClient
	def self.location_details(latitude, longitude)
		location = Geocoder.search(latitude+','+longitude)
		{province: location.first.state, city: location.first.sub_state}
	end
end