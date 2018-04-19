require 'rails_helper'

RSpec.describe ContestPlayJob, type: :job do
  let!(:id) { 5 }
  let!(:contest) { Contest.new(id: id) }

  describe ".enqueue" do
    subject { described_class.enqueue(contest: contest) }

    it "enqueues a contest" do
      expect do
        subject
      end.to have_enqueued_job.with(contest_id: id)
    end
  end

  describe "#perform" do
    let!(:configured_job) do 
      described_class.new.tap do |job|
        job.contest_play_service = contest_play_service
      end
    end
    let!(:contest_play_service) { double(ContestPlayService, call: nil) }
    subject { configured_job.perform(contest_id: id) }

    it "calls the ContestPlayService" do
      expect(contest_play_service).to receive(:call).with(contest_id: id)
      subject
    end
  end
end
