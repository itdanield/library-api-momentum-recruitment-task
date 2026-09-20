module Api
  class ReadersController < ApplicationController
    def index
      render json: Reader.all
    end

    def show
      render json: Reader.find(params[:id])
    end

    def create
      reader = Reader.create!(reader_params)

      render json: reader, status: :created
    end

    private

    def reader_params
      params.permit(:full_name, :email, :card_number)
    end
  end
end
