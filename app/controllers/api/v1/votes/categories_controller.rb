class Api::V1::Votes::CategoriesController < ApplicationController
	def index
    categories = VoteCategory.all()
    categories = categories.where("category LIKE ? or description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search]
    render json: {
    	status: 'success',
    	data: {
    		categories: categories
    	}
    }, status: 200
  end
  def create
  	category = VoteCategory.new(category_params)
  	if category.save 
  		render json: {
  			status: 'success',
  			data: category
  		}, status: 201
  	else
  		render json: {
  			status: 'fail',
  			data: 'fail when create category'
  		}, status: 422
  	end
  end
  private
  def category_params
  	params.permit(:category, :description)
  end
end
