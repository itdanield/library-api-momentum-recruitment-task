class ReturnBookService
  def self.call(book:)
    borrowing = book
      .borrowings
      .active
      .first

    raise BookNotBorrowedError, "Book is not borrowed" unless borrowing

    borrowing.update!(
      returned_at: Time.current
    )

    borrowing
  end
end
