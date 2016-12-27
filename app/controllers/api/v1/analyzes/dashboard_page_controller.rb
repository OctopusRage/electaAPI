class Api::V1::Analyzes::DashboardPageController < ApplicationController
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
			vote_id = current_user.votes.try(:last).try(:id)
		end
		if vote_id.nil?
			render json: {
				status: 'success',
				data: {
					empty_data: true
				}
			}, status: 200
		else
			vote = Vote.find(vote_id)
			vote_title = vote.title
			participant_count = vote.user_votes.count

			y_filter = params[:y_filter]
			x_filter = params[:x_filter]
			grouped_query = ""

			case x_filter
			when "years"
				grouped_query = "EXTRACT(year from user_votes.created_at)"
			when "month"
				grouped_query = "EXTRACT(month from user_votes.created_at)"
			else
				grouped_query = "DATE(user_votes.created_at)"
			end

			case y_filter
			when "degree"
				grouped_query_y = "degree"
			when "job"
				grouped_query_y = "job"
			else
				grouped_query_y = "gender"
			end

			today_participant_count = UserVote.where("DATE(user_votes.created_at) = ? AND vote_id = ?", DateTime.now.to_date, vote_id).count
			#user_vote =  User.joins("LEFT JOIN user_votes ON users.id = user_votes.user_id AND user_votes.vote_id = #{vote_id}")
			user_vote_cat =  UserVote.joins(:user).where("user_votes.vote_id  = ?", vote_id)
			top_region = user_vote_cat.order("count_all DESC").group(:city).count.try(:first).try(:first) || ""
			top_education = user_vote_cat.order("count_all DESC").group(:degree).count.try(:first).try(:first) || ""
			top_profesion = user_vote_cat.order("count_all DESC").group(:job).count.try(:first).try(:first) || ""

			modus_choice = vote.vote_options.as_json
			modus_choice = modus_choice.max_by{|e| e[:total_voter]}
			modus_choice = modus_choice[:options]

			filtered = user_vote_cat.group(grouped_query, grouped_query_y).count
			max_category = user_vote_cat.group(grouped_query_y).order("count_all DESC").count.try(:first) || ""
			max_category = ["", ""] if max_category.nil?
			min_category = user_vote_cat.group(grouped_query_y).order("count_all ASC").count.try(:first) || ""
			min_category = ["", ""] if min_category.nil?
			hash_result = {}
			hash_extra = {}
			filtered.map { |e|
				if e.first[0] # if there's nil record then save to tmp_nil value
					tmp_key_prim = e.first[0]
					tmp_key = e.first[1]
					tmp_val = e.second
					if hash_result["#{tmp_key_prim}"].nil?
						hash_result = hash_result.merge("#{tmp_key_prim}" => {"#{tmp_key}" => tmp_val})
						hash_extra = hash_extra.merge({"#{tmp_key}" => 0})
					else
						if hash_result["#{tmp_key_prim}"]["#{tmp_key}"].nil? 
							hash_result["#{tmp_key_prim}"]["#{tmp_key}"] = tmp_val
							hash_extra = hash_extra.merge({"#{tmp_key}" => 0})
						else
							hash_result["#{tmp_key_prim}"]["#{tmp_key}"] = hash_result["#{tmp_key_prim}"]["#{tmp_key}"]+tmp_val
							hash_extra = hash_extra.merge({"#{tmp_key}" => 0})
						end
					end
				else
					
				end
			}
			hash_result_final = {}
			if hash_extra.count > 0
				hash_result.each { |e|
					tmp_hash = {}
					hash_extra.each { |e1|
						if !e.second.key?(e1.first)
							tmp_hash = tmp_hash.merge(e.second.merge({"#{e1.first}"=> e1.second}))
						else
							tmp_hash = tmp_hash.merge(e.second)
						end
					}
					hash_result_final = hash_result_final.merge({"#{e.first}"=> tmp_hash})
				}
			else
				hash_result_final = hash_result
			end


			#filtered = UserVote.joins(:vote_option).where("vote_options.vote_id = ?", vote_id).group(grouped_query, :vote_option).count if y_filter== "options"
			render json:{
				status: 'success',
				data: {
					stat: {
						vote_id: vote_id,
						vote_title: vote_title,
						participant_count: participant_count,
						today_participant_count: today_participant_count,
						top_profesion: top_profesion,
						top_education: top_education,
						top_region: top_region,
						modus_choice: modus_choice,
						max_value: max_category,
						min_value: min_category
					},
					chart: hash_result_final
				}
			}, status: 200
		end
	end
end
