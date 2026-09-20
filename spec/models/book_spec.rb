require 'rails_helper'

RSpec.describe Book, type: :model do
  subject(:book) { build(:book) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:author) }

  it "validates unique serial number" do
    existing = create(:book)

    duplicate = build(
      :book,
      serial_number: existing.serial_number
    )

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:serial_number]).to include("has already been taken")
  end

  it do
    is_expected.to allow_value("123456")
      .for(:serial_number)
  end

  it do
    is_expected.not_to allow_value("12345")
      .for(:serial_number)
  end

  it do
    is_expected.not_to allow_value("abcdef")
      .for(:serial_number)
  end
end
