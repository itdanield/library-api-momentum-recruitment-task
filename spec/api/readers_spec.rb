require "rails_helper"

RSpec.describe "API::Readers", type: :request do
  describe "GET /api/readers" do
    let!(:readers) { create_list(:reader, 3) }

    it "returns all readers" do
      get "/api/readers"

      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)

      expect(response_json.size).to eq(3)

      readers.each do |reader|
        expect(response_json).to include(
          a_hash_including(
            "id" => reader.id,
            "full_name" => reader.full_name,
            "email" => reader.email,
            "card_number" => reader.card_number
          )
        )
      end
    end
  end

  describe "GET /api/readers/:id" do
    let!(:reader) { create(:reader) }
    let(:not_existing_id) { 999 }

    it "returns a single reader" do
      get "/api/readers/#{reader.id}"

      expect(response).to have_http_status(:ok)

      response_json = JSON.parse(response.body)

      expect(response_json).to include(
        "id" => reader.id,
        "full_name" => reader.full_name,
        "email" => reader.email,
        "card_number" => reader.card_number
      )
    end

    it "returns 404 when reader is not found" do
      get "/api/readers/#{not_existing_id}"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/readers" do
    let(:params) do
      {
        full_name: "Jan Kowalski",
        email: "jan@example.com",
        card_number: "123456"
      }
    end

    it "creates a reader" do
      expect do
        post "/api/readers", params: params
      end.to change(Reader, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "does not create a reader with invalid params" do
      expect do
        post "/api/readers", params: {
          full_name: "",
          email: "",
          card_number: ""
        }
      end.not_to change(Reader, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
