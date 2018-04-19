require 'rails_helper'

RSpec.describe CompleteContestTransitionService do
  let!(:contest_type) { ContestType::PotatoRacingContestType.name }
  let!(:first_competitor) { SecureRandom.uuid }
  let!(:second_competitor) { SecureRandom.uuid }
  let!(:winner_id) { first_competitor }
  let!(:contest) do 
    ContestCreationService.call(
      contest_type: contest_type, 
      first_competitor: first_competitor, 
      second_competitor: second_competitor
    ).contest
  end

  let!(:time) { class_double(Time, now: Time.now) }
  let!(:configured_service) { described_class.new(time: time) }

  describe "#call" do
    subject { configured_service.call(winner_id: winner_id, contest: contest) }

    context "transition succeeded" do
      it "returns success" do
        expect(subject).to be_success
      end

      it "sets the status to completed" do
        expect(subject.contest.status).to eq(Contest::Status::COMPLETED)
      end

      it "sets the winner" do
        expect(subject.contest.winner).to eq(winner_id)
      end

      it "sets the completed_at to now" do
        expect(subject.contest.completed_at).to eq(time.now)
      end
    end

    context "transition failed" do
      before do
        allow_any_instance_of(Contest).to receive(:update).and_return(false)
      end

      it "does not return success" do
        expect(subject).to_not be_success
      end
    end
  end
end
