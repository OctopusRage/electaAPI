class Api::V1::VotesController < ApplicationController
  def index
    vote = Vote.all
    vote = vote.page(params[:page]) if params[:page]
    vote = vote.limit(params[:limit]) if params[:limit]
    total = vote.count
    render json: {
      status: 'success',
      data: {
        votes: vote,
        total: total
      }
    }, status: 200
  end

  def show
    vote = Vote.find(params[:id])
    render json: {
      status: 'success',
      data: vote.as_detailed_json
    }, status: 200
  end

end