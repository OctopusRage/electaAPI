class Api::V1::VoteCategoriesController < ApplicationController
  def index
    categories = VoteCategories.all
    render json: {
      status: 'success', 
      data: categories
    }, status: 200
  end
end