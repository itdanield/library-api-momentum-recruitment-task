require "rails_helper"

RSpec.describe "API::Books", type: :request do
  describe "GET /api/books" do
    let!(:books) { create_list(:book, 3) }

    it "returns all books" do
      get "/api/books"

      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)

      expect(response_json.size).to eq(3)
      expect(response.content_type).to include("application/json")

      books.each do |book|
        expect(response_json).to include(
          a_hash_including(
            "id" => book.id,
            "title" => book.title,
            "author" => book.author,
            "serial_number" => book.serial_number
          )
        )
      end
    end
  end

  describe "GET /api/books/:id" do
    let!(:book) { create(:book) }

    it "returns a single book" do
      get "/api/books/#{book.id}"

      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)

      expect(response_json).to include(
        "id" => book.id,
        "title" => book.title,
        "author" => book.author,
        "serial_number" => book.serial_number
      )
    end

    it "returns error 404 when book is not found" do
      get "/api/books/999"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/books" do
    let(:params) do
      {
        title: "Clean Code",
        author: "Robert Martin",
        serial_number: "123456"
      }
    end

    it "creates a book" do
      expect do
        post "/api/books", params: params
      end.to change(Book, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "does not create a book with invalid params" do
      expect do
        post "/api/books", params: {
          title: "",
          author: "",
          serial_number: ""
        }
      end.not_to change(Book, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /api/books/:id" do
    let!(:book) { create(:book) }

    it "deletes a book" do
      expect do
        delete "/api/books/#{book.id}"
      end.to change(Book, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 when book does not exist" do
      delete "/api/books/999"

      expect(response).to have_http_status(:not_found)
    end
  end

    describe "POST /api/books/:id/borrow" do
    let!(:book) { create(:book) }
    let!(:reader) { create(:reader) }

    it "borrows a book" do
      expect do
        post "/api/books/#{book.id}/borrow",
             params: { reader_id: reader.id }
      end.to change(Borrowing, :count).by(1)

      expect(response).to have_http_status(:created)

      borrowing = Borrowing.last

      expect(borrowing.book).to eq(book)
      expect(borrowing.reader).to eq(reader)
      expect(borrowing.returned_at).to be_nil
    end

    it "returns 404 when book does not exist" do
      post "/api/books/999/borrow",
           params: { reader_id: reader.id }

      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 when reader does not exist" do
      post "/api/books/#{book.id}/borrow",
           params: { reader_id: 999 }

      expect(response).to have_http_status(:not_found)
    end

    it "does not allow borrowing already borrowed book" do
      create(
        :borrowing,
        book: book,
        reader: reader,
        returned_at: nil
      )

      post "/api/books/#{book.id}/borrow",
           params: { reader_id: reader.id }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "POST /api/books/:id/return_book" do
    let!(:book) { create(:book) }
    let!(:reader) { create(:reader) }

    let!(:borrowing) do
      create(
        :borrowing,
        book: book,
        reader: reader,
        returned_at: nil
      )
    end

    it "returns a borrowed book" do
      post "/api/books/#{book.id}/return_book"

      expect(response).to have_http_status(:ok)

      expect(
        borrowing.reload.returned_at
      ).not_to be_nil
    end

    it "returns 404 when book does not exist" do
      post "/api/books/999/return_book"

      expect(response).to have_http_status(:not_found)
    end

    it "returns error when book is not borrowed" do
      borrowing.update!(
        returned_at: Time.current
      )

      post "/api/books/#{book.id}/return_book"

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
