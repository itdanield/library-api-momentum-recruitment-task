module Api
  class BooksController < ApplicationController
    def index
      render json: Book.all
    end

    def show
      render json: Book.find(params[:id])
    end

    def create
      book = Book.create!(book_params)

      render json: book, status: :created
    end

    def destroy
      Book.find(params[:id]).destroy!

      head :no_content
    end

    def borrow
      book = Book.find(params[:id])
      reader = Reader.find(params[:reader_id])

      borrowing = BorrowBookService.call(
        book: book,
        reader: reader
      )

      render json: borrowing, status: :created
    end

    def return_book
      book = Book.find(params[:id])

      borrowing = ReturnBookService.call(
        book: book
      )

      render json: borrowing
    end

    private

    def book_params
      params.permit(:title, :author, :serial_number)
    end
  end
end
