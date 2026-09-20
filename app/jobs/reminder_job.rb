class ReminderJob < ApplicationJob
  queue_as :default

  def perform
    Borrowing.active.find_each do |borrowing|
      next unless borrowing.due_date.to_date == 3.days.from_now.to_date

      Rails.logger.info(
        {
          email: borrowing.reader.email,
          subject: "Book return reminder",
          book: borrowing.book.title,
          due_date: borrowing.due_date
        }.to_json
      )
    end
  end
end
