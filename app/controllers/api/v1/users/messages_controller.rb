class Api::V1::Users::MessagesController < ApplicationController
  before_action :authorize_user
  def show
    message = Message.find(params[:id])
    if message
      if message.to == current_user.id
        render json: {
          status: 'success',
          data: message
        }, status: 200
      else
        render json: {
          status: 'fail',
          data: {
            messages: 'Messaage not found'
          }
        }, status: 422
      end
    else
      render json: {
        status: 'fail',
        data: {
          messages: 'Fail to fetch inbox'
        }
      }, status: 422
    end
  end

  def index
    messages = Message.where(to: current_user.id)
    if messages
      total_count = messages.count
      messages = messages.limit(params[:limit]) if params[:limit]
      messages = messages.page(params[:page]) if params[:page]
      messages = messages.page(params[:page]).per(params[:limit]) if (params[:limit] && params[:page])
      count = messages.count

      render json: {
        status: 'success',
        data: {
          messages: messages,
          count: count,
          total: total_count
        }
      }, status: 200
    else
      render json: {
        status: 'fail',
        data: {
          messages: 'Fail to fetch inbox'
        }
      }, status: 422
    end
  end

  def create
    mp = message_params
    if mp[:to] = User.find_by(email: mp[:to]).try(:id)
      message = current_user.messages.create(mp)
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

  def sentbox
    messages = current_user.messages
    if messages
      total_count = messages.count
      messages = messages.limit(params[:limit]) if params[:limit]
      messages = messages.page(params[:page]) if params[:page]
      messages = messages.page(params[:page]).per(params[:limit]) if (params[:limit] && params[:page])
      count = messages.count

      render json: {
        status: 'success',
        data: {
          messages: messages,
          count: count,
          total: total_count
        }
      }, status: 200
    else
      render json: {
        status: 'fail',
        data: {
          messages: 'Fail to fetch inbox'
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
