require 'rails_helper'

RSpec.describe ContestInitializationService do
  let!(:invalid_contest_creation_validation_service_result) { instance_double(ContestCreationValidationService, success?: false) }
  let!(:valid_contest_creation_validation_service_result) { instance_double(ContestCreationValidationService, success?: true) }
  let!(:contest_creation_validation_service) { class_double(ContestCreationValidationService, call: nil) }

  let!(:contest) { Contest.new }
  let!(:invalid_contest_creation_service_result) { instance_double(ContestCreationService, success?: false) }
  let!(:valid_contest_creation_service_result) { instance_double(ContestCreationService, success?: true, contest: contest) }
  let!(:contest_creation_service) { class_double(ContestCreationService, call: nil) }

  let!(:configured_service) do
    described_class.new(
      contest_creation_validation_service: contest_creation_validation_service,
      contest_creation_service: contest_creation_service
    )
  end

  describe "#call" do
    let!(:contest_type) { ContestType::PotatoRacingContestType.name }
    let!(:first_competitor) { SecureRandom.uuid }
    let!(:second_competitor) { SecureRandom.uuid }
    subject { configured_service.call(contest_type: contest_type, first_competitor: first_competitor, second_competitor: second_competitor) }

    context "validator is successful" do
      before do
        allow(contest_creation_validation_service).to receive(:call).with(
          contest_type: contest_type,
          first_competitor: first_competitor,
          second_competitor: second_competitor
        ).and_return(valid_contest_creation_validation_service_result)
      end

      context "creation is successful" do
        before do
          allow(contest_creation_service).to receive(:call).with(
            contest_type: contest_type,
            first_competitor: first_competitor,
            second_competitor: second_competitor
          ).and_return(valid_contest_creation_service_result)
        end

        it "is success" do
          expect(subject).to be_success
        end

        it "returns the contest" do
          expect(subject.contest).to eq(contest)
        end
      end

      context "creation is not successful" do
        before do
          allow(contest_creation_service).to receive(:call).with(
            contest_type: contest_type,
            first_competitor: first_competitor,
            second_competitor: second_competitor
          ).and_return(invalid_contest_creation_service_result)
        end

        it "is not success" do
          expect(subject).to_not be_success
        end
      end
    end

    context "validator is not successful" do
      before do
        allow(contest_creation_validation_service).to receive(:call).with(
          contest_type: contest_type,
          first_competitor: first_competitor,
          second_competitor: second_competitor
        ).and_return(invalid_contest_creation_validation_service_result)
      end

      it "is not success" do
        expect(subject).to_not be_success
      end

      it "returns errors" do
        expect(true).to eq(false)
      end
    end
  end
end
