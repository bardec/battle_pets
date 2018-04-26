require 'rails_helper'

RSpec.describe ContestPlayService do
  let!(:contest_id) { 5 }
  let!(:contest_type_class) { ContestType::PotatoRacingContestType }
  let!(:contest_type) { contest_type_class.name }
  let!(:first_competitor) { SecureRandom.uuid }
  let!(:second_competitor) { SecureRandom.uuid }
  let!(:first_competitor_score) { 20 }
  let!(:second_competitor_score) { 10 }

  let!(:contest_repo) { class_double(Contest, find: contest) }
  let!(:contest) do
    instance_double(
      Contest,
      id: contest_id,
      first_competitor: first_competitor,
      second_competitor: second_competitor,
      contest_type: contest_type,
    )
  end

  let!(:complete_contest_transition_service) { class_double(CompleteContestTransitionService, call: nil) }
  let!(:single_round_play_service) { class_double(SingleRoundPlayService, call: nil) }
  let!(:forever_round_play_service) { class_double(ForeverRoundPlayService, call: nil) }

  let!(:configured_service) do
    described_class.new(
      contest_repo: contest_repo,
      complete_contest_transition_service: complete_contest_transition_service,
      single_round_play_service: single_round_play_service,
      forever_round_play_service: forever_round_play_service
    )
  end

  describe "#call" do
    subject { configured_service.call(contest_id: contest_id) }
    let!(:winner_id) { first_competitor }

    context "single round type" do
      before do
        allow(single_round_play_service).to receive(:call).with(contest: contest).and_return(winner_id)
      end

      it "plays the service correctly" do
        expect(single_round_play_service).to receive(:call).with(contest: contest)
        subject
      end

      it "uses the correct winner" do
        expect(complete_contest_transition_service).to receive(:call).with(winner_id: winner_id, contest: contest)
        subject
      end
    end

    context "forever round type" do
      let!(:contest_type_class) { ContestType::BeerDrinkingContestType }
      before do
        allow(forever_round_play_service).to receive(:call).with(contest: contest).and_return(winner_id)
      end

      it "plays the service correctly" do
        expect(forever_round_play_service).to receive(:call).with(contest: contest)
        subject
      end

      it "uses the correct winner" do
        expect(complete_contest_transition_service).to receive(:call).with(winner_id: winner_id, contest: contest)
        subject
      end
    end
  end
end
