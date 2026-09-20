require "rails_helper"

RSpec.describe BorrowBookService do
  describe ".call" do
    let(:book) { create(:book) }
    let(:reader) { create(:reader) }

    it "creates borrowing" do
      expect do
        described_class.call(
          book: book,
          reader: reader
        )
      end.to change(Borrowing, :count).by(1)
    end

    it "raises error when book is already borrowed" do
      create(
        :borrowing,
        book: book,
        reader: reader,
        returned_at: nil
      )

      expect do
        described_class.call(
          book: book,
          reader: reader
        )
      end.to raise_error(StandardError)
    end
  end
end
