class Api::V1::Users::MessagesController < ApplicationController
  before_action :authorize_user
  def show
    message = current_user.messages.find(params[:id])
    render json: {
      status: 'success',
      data: message
    }, status: 200
  end

  def index
    messages = current_user.messages
    messages.page(params[:page]) if params[:page]
    messages.limit(params[:limit]) if params[:limit]
    
    render json: {
      status: 'success',
      data: {
        messages: messages
      }
    }, status: 200
  end

  def create
    if message_params[:to] = User.find_by(email: message_params[:to]).id
      message = current_user.messages.create(message_params)
      if message.save
        render json: {
          status: 'success',
          data: message
        }, status: 201
      else
        render json: {
          status: 'fail',
          data: message.errors.first
        }, status: 422
      end
    else
      render json: {
        status: 'fail',
        data: {
          message: "user not found"
        }
      }, status: 422
    end
  end

  def destroy
    message = current_user.messages.find(params[:id])
    message.delete
    render json: {
      status: 'success'
    }, status:204
  end

  def sent_box
    messages = Message.where(from: current_user.id)
    render json: {
      status: 'success',
      data: messages
    }, status: 200
  end

  private
    def message_params
      params.permit(
        :to ,:subject, :message)
    end
end
