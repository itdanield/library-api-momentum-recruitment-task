class Borrowing < ApplicationRecord
  belongs_to :book
  belongs_to :reader

  validates :borrowed_at, presence: true
  validates :due_date, presence: true

  scope :active, -> { where(returned_at: nil) }
end
