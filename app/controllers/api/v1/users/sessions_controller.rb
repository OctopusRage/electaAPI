class Api::V1::Users::SessionsController < ApplicationController
  def create
    email = params['email']
    password = params['password']
    user = User.find_by(email: email)
    if user
      if (user.valid_password? password) && !user.email.nil?
        sign_in user, store: false
        render json: {
          status: 'success', 
          data: user.credential_as_json
        }, status: 200
      else
        render json: {
          status: 'fail',
          data: {
            messages: 'invalid username or password'
          }
        }, status: 422
      end
    else
      render json: {
        status: 'fail',
        data: {
          messages: 'invalid username or password'
        }
      }, status: 422
    end
  end
end

