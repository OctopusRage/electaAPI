class Api::V1::Files::VotesController < ApplicationController
  before_action :authorize_user
  before_action :ensure_raw_file, only: :create

  def create
    vote = Vote.find(params[:vote_id])
    file_upload = FileUpload.create!(
      raw: @raw_file,
      uploader: vote
    )

    render json:{
      status: 'fail',
      message: "only picture can be uploaded"            
    },status:422 and return unless file_upload.image? 

    folder = "images"

    cloudinary = Cloudinary::Uploader.upload(
      file_upload.raw.url, resource_type: 'auto',
      folder: folder)
    file_upload.update!(url: cloudinary['url'])
    vote.update(vote_pict_url: file_upload.url)
    render json: {
      status: 'success',
      data: {
        file: file_upload
      }
    }, status: 201, base_url: request.base_url
  end

  private

  def ensure_raw_file
    @raw_file = params[:raw_file]

    render json: {
      status: 'fail',
      message: 'invalid raw file'
    }, status: 422 unless @raw_file
  end
end
