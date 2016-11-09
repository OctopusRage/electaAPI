class Api::V1::Utilities::DegreesController < ApplicationController
  def index
    data = User::AVAILABLE_DEGREE
    render json: {
      status: 'success', 
      data: data
    }, status:200
  end
end