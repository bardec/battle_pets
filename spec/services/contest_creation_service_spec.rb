require 'rails_helper'

RSpec.describe ContestCreationService do
  let!(:contest_repo) { Contest }
  let!(:configured_service) { described_class.new(contest_repo: contest_repo) }

  describe "call" do
    let!(:contest_type) { ContestType::PotatoRacingContestType.name }
    let!(:first_competitor) { SecureRandom.uuid }
    let!(:second_competitor) { SecureRandom.uuid }
    subject do
      configured_service.call(
        contest_type: contest_type, 
        first_competitor: first_competitor, 
        second_competitor: second_competitor
      )
    end

    context "successful creation" do
      it "returns success if it is created" do
        expect(subject).to be_success
      end

      it "is of type contest_type" do
        expect(subject.contest.contest_type).to eq(contest_type)
      end

      it "in progress" do
        expect(subject.contest.status).to eq(Contest::Status::IN_PROGRESS)
      end

      it "has the correct first_competitor" do
        expect(subject.contest.first_competitor).to eq(first_competitor)
      end

      it "has the correct second_competitor" do
        expect(subject.contest.second_competitor).to eq(second_competitor)
      end
    end

    context "creation failed" do
      let!(:failed_contest_result) { instance_double(Contest, persisted?: false) }
      let!(:contest_repo) { class_double(Contest, create: failed_contest_result) }

      it "is not success" do
        expect(subject).to_not be_success
      end
    end
  end
end
