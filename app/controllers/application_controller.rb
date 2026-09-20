class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid do |error|
    render json: {
      errors: error.record.errors.full_messages
    }, status: :unprocessable_content
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: {
      error: "Record not found"
    }, status: :not_found
  end

  rescue_from BookAlreadyBorrowedError,
              BookNotBorrowedError do |error|
    render json: {
      error: error.message
    }, status: :unprocessable_content
  end
end
