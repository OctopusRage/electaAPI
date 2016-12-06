class Api::V1::Analyzes::DashboardPage < ApplicationController
	before_action :authorize_user
	def top_page
		follower_count = UserFollower.where(following_id: current_user.id).count
    following_count = UserFollower.where(follower_id: current_user.id).count
    total_vote = current_user.votes.all.count
    today_participant_count = Vote.joins(:user_votes)
    	.where("votes.user_id = ? AND DATE(user_votes.created_at) = ?", current_user.id, DateTime.now.to_date).count
		render json: {
			follower_count: follower_count,
			following_count: following_count,
			total_vote: total_vote,
			today_participant_count: today_participant_count
		}
	end

	def chart_stats
		payload = {}
		if params[:based_on] == 'popular' 
			vote_id = Vote.joins(:user_votes)
				.where("votes.user_id = ?", current_user.id)
				.order("count_all DESC")
				.group(:vote_id)
				.count.try(:first).try(:first)
		else
			vote_id = Vote.last.id
		end
		vote = Vote.find(vote_id)
		participant_count = vote.user_votes.count
		today_participant_count = vote.where("DATE(user_votes.created_at) = ?", DateTime.now.to_date).count
		user_vote =  UserVote.joins(:user).where("vote_id = ?", vote_id)
		top_education = user_vote.order("count_all DESC").group(:degree).count.try(:first).try(:first)
		top_profesion = user_vote.order("count_all DESC").group(:job).count.try(:first).try(:first)
		y_filter = params[:y_filter]
		x_filter = params[:x_filter]
		grouped_query = ""

		case x_filter
		when "years"
			grouped_query = "YEARS(user_votes.created_at)" 
		when "month"
			grouped_query = "MONTH(user_votes.created_at)"
		else
			grouped_query = "DATE(user_votes.created_at)"
		end
				
		filtered = user_vote.group(grouped_query, :gender).count if y_filter=="gender"
		filtered = user_vote.group(grouped_query, :degree,).count if y_filter=="degree"
		filtered = user_vote.group(grouped_query, :job).count if y_filter=="job"
		filtered = UserVote.joins(:vote_option).where("vote_options.vote_id = ?", vote_id).group(grouped_query, :vote_option).count if y_filter== "options"
		render json:{
			status: 'success',
			data: {
				stat: {
					participant_count: participant_count,
					today_participant_count: today_participant_count,
					top_profesion: top_profesion,
					top_education: top_education
				}
				chart: {
					filtered: filtered
				}
			}
		}, status: 200
	end
end