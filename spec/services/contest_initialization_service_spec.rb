require 'rails_helper'

RSpec.describe ContestInitializationService do
  let!(:invalid_get_pet_service_result) { instance_double(PetApi::GetPetService, success?: false) }
  let!(:valid_get_pet_service_result) { instance_double(PetApi::GetPetService, success?: true) }
  let!(:get_pet_service) { class_double(PetApi::GetPetService, call: nil) }

  let!(:invalid_contest_creation_service_result) { instance_double(ContestCreationService, success?: false) }
  let!(:valid_contest_creation_service_result) { instance_double(ContestCreationService, success?: true) }
  let!(:contest_creation_service) { class_double(ContestCreationService, call: nil) }

  let!(:configured_service) do
    described_class.new(
      get_pet_service: get_pet_service,
      contest_creation_service: contest_creation_service
    )
  end

  context "#call" do
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


    context "valid state" do
      context "when both competitors are found and the contest is created" do
        before do
          allow(get_pet_service).to receive(:call).with(pet_id: first_competitor).and_return(valid_get_pet_service_result)
          allow(get_pet_service).to receive(:call).with(pet_id: second_competitor).and_return(valid_get_pet_service_result)
          allow(contest_creation_service).to receive(:call).and_return(valid_contest_creation_service_result)
        end

        it "is success" do
          expect(subject).to be_success
        end
      end
    end

    context "invalid state" do
      context "when the first_competitor is not found" do
        before do
          allow(get_pet_service).to receive(:call).with(pet_id: first_competitor).and_return(invalid_get_pet_service_result)
          allow(get_pet_service).to receive(:call).with(pet_id: second_competitor).and_return(valid_get_pet_service_result)
        end

        it "is not success" do
          expect(subject).to_not be_success
        end
      end

      context "when the second_competitor is not found" do
        before do
          allow(get_pet_service).to receive(:call).with(pet_id: first_competitor).and_return(valid_get_pet_service_result)
          allow(get_pet_service).to receive(:call).with(pet_id: second_competitor).and_return(invalid_get_pet_service_result)
        end

        it "is not success" do
          expect(subject).to_not be_success
        end
      end

      context "when both the contest_type does not exist" do
        let!(:contest_type) { "invalid_type" }
        before do
          allow(get_pet_service).to receive(:call).with(pet_id: first_competitor).and_return(valid_get_pet_service_result)
          allow(get_pet_service).to receive(:call).with(pet_id: second_competitor).and_return(valid_get_pet_service_result)
        end

        it "is not success" do
          expect(subject).to_not be_success
        end
      end

      context "when the ContestCreationService fails" do
        before do
          allow(get_pet_service).to receive(:call).with(pet_id: first_competitor).and_return(valid_get_pet_service_result)
          allow(get_pet_service).to receive(:call).with(pet_id: second_competitor).and_return(valid_get_pet_service_result)
          allow(contest_creation_service).to receive(:call).and_return(invalid_contest_creation_service_result)
        end

        it "is not success" do
          expect(subject).to_not be_success
        end
      end
    end
  end
end
