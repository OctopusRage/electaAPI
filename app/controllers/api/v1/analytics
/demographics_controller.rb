class Api::V1::Analytics::DemographicsController < AppicationController
	before_action :authorize_user
	def show
		if params[:type] == "province"
			data = User.where(province: params[:location_name])
			total_user = data.count
			most_degree = data.group(:job).count
			most_job =  data.select("COUNT(*) AS count_all, job as job").group("job").order("count_all DESC").first
		else
		end
	end
end