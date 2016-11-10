class Api::V1::Analyzes::DemographicsController < ApplicationController
	before_action :authorize_user
	def show
		if params[:type] == "province"
			data = User.where(province: params[:location_name])
			total_user = data.count
			#most_degree = data.group(:job).count
			#most_job =  data.select("COUNT(*) AS count_all, job as job").group("job").order("count_all DESC").first
			render json: {
				status: 'success',
				data: data
			}, status: 200
		else
			render json: {
				status: 'fail', 
				data: 's'
			}, status: 422
		end
	end
end