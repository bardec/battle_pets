require 'spec_helper'

RSpec.describe PetApi::Client do
  context "self.get" do
    let!(:pet_id) { SecureRandom.uuid }
    subject { PetApi::Client.get(pet_id: pet_id) }

    context "found pet" do
      it "returns a response" do
        VCR.use_cassette('found_pet', match_requests_on: [:any_pet_matcher]) do
          expect(subject).to be_a(Faraday::Response)
          expect(subject.status).to eq(200)
        end
      end
    end

    context "missing pet" do
      it "returns a response" do
        VCR.use_cassette('missing_pet', match_requests_on: [:any_pet_matcher]) do
          expect(subject).to be_a(Faraday::Response)
          expect(subject.status).to eq(404)
        end
      end
    end
  end
end
