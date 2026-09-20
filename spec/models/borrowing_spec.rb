require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  subject(:borrowing) { build(:borrowing) }

  it { is_expected.to belong_to(:book) }
  it { is_expected.to belong_to(:reader) }

  describe ".active" do
    let!(:active_borrowing) { create(:borrowing) }
    let!(:returned_borrowing) { create(:borrowing, returned_at: Time.current) }

    it "returns only active borrowings" do
      expect(Borrowing.active).to contain_exactly(active_borrowing)
    end
  end
end
