class Reader < ApplicationRecord
  has_many :borrowings, dependent: :destroy

  validates :full_name, presence: true

  validates :card_number,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A\d{6}\z/,
              message: "must be a six-digit number"
            }

  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            }
end
