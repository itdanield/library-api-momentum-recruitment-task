require 'rails_helper'

RSpec.describe Reader, type: :model do
  subject(:reader) { build(:reader) }

  it { is_expected.to have_many(:borrowings).dependent(:destroy) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:card_number) }

    it "validates uniqueness of card number" do
      existing = create(:reader)
      duplicate = build(:reader, card_number: existing.card_number)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:card_number]).to include("has already been taken")
    end

    it "validates uniqueness of email" do
      existing = create(:reader)
      duplicate = build(:reader, email: existing.email)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("has already been taken")
    end
  end

  describe "formats" do
    it { is_expected.to allow_value("123456").for(:card_number) }
    it { is_expected.to allow_value("test@example.com").for(:email) }

    it { is_expected.not_to allow_value("12345").for(:card_number) }
    it { is_expected.not_to allow_value("abcef").for(:card_number) }

    it { is_expected.not_to allow_value("invalid_email").for(:email) }
    it { is_expected.not_to allow_value("test@").for(:email) }
  end
end
