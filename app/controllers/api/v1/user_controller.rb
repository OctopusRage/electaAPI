class Api::V1::UserController < ApplicationController
  def create
    user = User.new(user_params)
    if (user.valid_password? user_params[:password]) && same_password  
      if user.save
        render json: {
          status: 'success',
          data: user
        }, status:201
      else
        render json: {
          status: 'fail',
          data: user.errors.first.second
        }, status:422
      end
    else
      render json: {
        status: 'fail',
        data: 'password didnt match'
      }, status:422
    end
  end  

  def show
    user = User.find(params[:id]).as_profile_json
    render json: {
      status: 'success',
      data: user
    }, status:200
  end

  private 
    def same_password
      user_params[:password] == user_params[:password_confirmation]
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name,
        :city ,:grade ,:latitude, :longitude, :degree,
        :job , :date_of_birth, :province, :phone_number, :avatar_url ,
        :verified, :gender )
    end
end