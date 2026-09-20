class BorrowBookService
  def self.call(book:, reader:)
    raise BookAlreadyBorrowedError, "Book already borrowed" if book.borrowed?

    Borrowing.create!(
      book: book,
      reader: reader,
      borrowed_at: Time.current,
      due_date: 30.days.from_now
    )
  end
end
