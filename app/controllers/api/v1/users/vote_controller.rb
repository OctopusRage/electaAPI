class Api::V1::Users::VoteController < ApplicationController
  before_action :authorize_user
  def create
    vote = current_user.votes.new(vote_params)

    vote.generate_vote_options(params[:options])
    if vote.save
      render json: {
        status: 'success',
        data: vote
      }, status: 201
    else
      render json: {
        status: 'fail',
        data: vote.errors
      }, status: 422
    end
  end

  def update
    vote = current_user.votes.find(params[:id])
    if vote.update(vote_params)
      render json:{
        status: 'success',
        data: vote
      }, status: 200
    else
      render json:{
        status: 'fail',
        data: vote.errors
      }, status: 422
    end
  end

  def index
    votes = current_user.votes
    votes = votes.order(id: :desc)
    count = votes.count
    votes = votes.page(params[:page]) if params[:page]
    votes = votes.limit(params[:limit]) if params[:limit]
    votes = votes.page(params[:page]).per(params[:limit]) if (params[:limit] && params[:page])
    total = votes.count
    render json: {
      status: 'success',
      data: {
        votes: votes,
        count: count,
        total: total
      }
    }, status: 200
  end

  def destroy
    vote = current_user.votes.find(params[:id])
    vote.delete
    render json: {
      status: 'success'
    }, status:204
  end



  private
    def vote_params
      params.permit(:title, :description, :category_id, :started_at, :ended_at, :options)
    end

end
