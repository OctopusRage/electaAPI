class Api::V1::Users::LocationsController < ApplicationController
	def show
		latitude = params[:latitude]
		longitude = params[:longitude]
		byebug
		location = GeocoderClient.location_details(latitude, longitude)
		render json: {
			status: success,
			data: location
		}, status: 200
	end
end