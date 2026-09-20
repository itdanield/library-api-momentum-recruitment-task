require "rails_helper"

RSpec.describe ReminderJob, type: :job do
  describe "#perform" do
    let(:reader) { create(:reader) }
    let(:book) { create(:book) }

    let!(:borrowing) do
      create(
        :borrowing,
        reader: reader,
        book: book,
        due_date: 3.days.from_now
      )
    end

    it "logs reminder for borrowings due in 3 days" do
      allow(Rails.logger).to receive(:info)

      described_class.perform_now

      expect(Rails.logger)
        .to have_received(:info)
        .with(a_string_including(reader.email))
    end
  end
end
