require 'rails_helper'

RSpec.describe ContestType::BaseContestType do
  subject { described_class }

  context ".name" do
    it "raises" do
      expect do
        subject.name
      end.to raise_exception(NotImplementedError)
    end
  end

  context ".rounds" do
    it "defaults to one" do
      expect(subject.rounds).to eq(1)
    end
  end

  context ".score_competitor" do
    let!(:pet) { double(PetApi::Pet) }

    it "raises" do
      expect do
        subject.score_competitor(pet: pet)
      end.to raise_exception(NotImplementedError)
    end
  end
end
