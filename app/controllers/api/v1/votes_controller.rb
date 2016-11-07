class Api::V1::VotesController < ApplicationController
  def index
    vote = Vote.all.desc
    vote = vote.page(params[:page]) if params[:page]
    vote = vote.limit(params[:limit]) if params[:limit]
    total_in_query = vote.count
    total = Vote.all.count
    render json: {
      status: 'success',
      data: {
        votes: vote,
        count: total_in_query,
        total: total
      }
    }, status: 200
  end

end