require 'rails_helper'

RSpec.describe ContestSerializer do
  let!(:configured_serializer) { described_class.new(contest) }

  context "#serializable_hash" do
    subject { configured_serializer.serializable_hash }

    context "in progress contest" do
      let!(:contest) do
        ContestCreationService.call(
          contest_type: 'potato_racing',
          first_competitor: SecureRandom.uuid,
          second_competitor: SecureRandom.uuid
        ).contest
      end

      it "serializes as expected" do
        expect(subject).to eq(
          id: contest.id,
          type: contest.contest_type,
          first_competitor: contest.first_competitor,
          second_competitor: contest.second_competitor,
          winner: contest.winner,
          status: contest.status,
          completed_at: contest.completed_at
        )
      end
    end

    context "completed contest" do
      let!(:contest) do
        in_progress_contest = ContestCreationService.call(
          contest_type: 'potato_racing',
          first_competitor: SecureRandom.uuid,
          second_competitor: SecureRandom.uuid
        ).contest

        CompleteContestTransitionService.call(
          winner_id: in_progress_contest.first_competitor, 
          contest: in_progress_contest
        ).contest
      end

      it "serializes as expected" do
        expect(subject).to eq(
          id: contest.id,
          type: contest.contest_type,
          first_competitor: contest.first_competitor,
          second_competitor: contest.second_competitor,
          winner: contest.winner,
          status: contest.status,
          completed_at: contest.completed_at
        )
      end
    end

  end
end
