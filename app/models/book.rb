class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy

  validates :title, presence: true
  validates :author, presence: true

  validates :serial_number,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A\d{6}\z/,
              message: "must be a six-digit number"
            }

  def borrowed?
    borrowings.where(returned_at: nil).exists?
  end
end
