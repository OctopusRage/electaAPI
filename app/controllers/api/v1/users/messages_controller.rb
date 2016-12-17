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
    render json: {
      status: 'success',
      data: messages
    }, status: 200
  end

  def create
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
  end

  def destroy
    message = current_user.messages.find(params[:message_id])
    message.delete
    render json: {
      status: 'success'
    }, status:204
  end

  private
    def message_params
      params.permit(
        :to ,:from ,:subject, :message)
    end
end
