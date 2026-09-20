require "rails_helper"

RSpec.describe ReturnBookService do
  describe ".call" do
    let(:book) { create(:book) }
    let(:reader) { create(:reader) }

    let!(:borrowing) do
      create(
        :borrowing,
        book: book,
        reader: reader,
        returned_at: nil
      )
    end

    it "returns borrowed book" do
      described_class.call(book: book)

      expect(
        borrowing.reload.returned_at
      ).not_to be_nil
    end

    it "raises error when book is not borrowed" do
      borrowing.update!(returned_at: Time.current)

      expect do
        described_class.call(book: book)
      end.to raise_error(StandardError)
    end
  end
end
