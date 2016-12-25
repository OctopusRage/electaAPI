class Api::V1::ImportCsvController < ApplicationController
  def create
    @raw_file = params[:raw_file]
    uploaded_io = @raw_file

    begin
      imported_data = User.import(uploaded_io.read)
      render json: {
        status: 'success',
        data: {
          imported_count: imported_data.count,
          imported_data: imported_data
        }
      }
    rescue Exception => e
      render json: {
        status: 'fail',
        message: e.message
      }, status: 422
    end
  end
end