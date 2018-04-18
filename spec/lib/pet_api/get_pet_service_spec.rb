require 'spec_helper'

RSpec.describe PetApi::GetPetService do
  let!(:pet_id) { SecureRandom.uuid }

  describe "#call" do
    subject { described_class.call(pet_id: pet_id) }

    context "pet is found" do
      around(:each) do |example| 
        VCR.use_cassette(
          "found_pet", 
          allow_playback_repeats: true, 
          match_requests_on: [:any_pet_matcher], 
          &example
        ) 
      end

      it "returns success" do
        expect(subject).to be_success
      end

      it "returns a configured pet" do
        recorded_body = PetApi::Client.get(pet_id: pet_id).body
        parsed_recorded_body = JSON.parse(recorded_body)
        expect(subject.pet.id).to eq(parsed_recorded_body["id"])
        expect(subject.pet.name).to eq(parsed_recorded_body["name"])
        expect(subject.pet.strength).to eq(parsed_recorded_body["strength"])
        expect(subject.pet.intelligence).to eq(parsed_recorded_body["intelligence"])
        expect(subject.pet.speed).to eq(parsed_recorded_body["speed"])
        expect(subject.pet.integrity).to eq(parsed_recorded_body["integrity"])
      end
    end

    context "pet is not found" do
      around(:each) do |example| 
        VCR.use_cassette(
          "missing_pet", 
          allow_playback_repeats: true, 
          match_requests_on: [:any_pet_matcher], 
          &example
        ) 
      end

      it "does not return success" do
        expect(subject).to_not be_success
      end

      it "does not return a pet" do
        expect(subject.pet).to eq(nil)
      end
    end
  end
end
