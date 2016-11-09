class Api::V1::Utilities::LocationsController < ApplicationController
	def show
		latitude = params[:latitude].to_str
		longitude = params[:longitude].to_str
		location = GeocoderClient.location_details(latitude, longitude)
		render json: {
			status: 'success',
			data: location
		}, status: 200
	end
end