class Api::V1::Users::ProfileController < ApplicationController
  before_action :authorize_user
  def show
    user = current_user
    render json: {
      status: 'success', 
      data: user
    }, status: 200
  end

  def update
    if current_user.update(user_params)
      render json: {
        status: 'success',
        data: current_user
      }
    else
      render json: {
        status: 'fail', 
        data: current_user.errors.first
      }
    end
  end
  private
    def user_params
      params.require(:user).permit(
        :city ,:grade ,:latitude, :longitude, :degree,
        :job , :date_of_birth, :province, :phone_number, :avatar_url ,
        :verified, :gender )
    end
end