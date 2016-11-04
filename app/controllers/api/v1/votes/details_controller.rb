class Api::V1::Votes::DetailsController < ApplicationController
	def show
    vote = Vote.find(params[:id])
    render json: {
      status: 'success',
      data: vote.as_detailed_json
    }, status: 200
  end
end