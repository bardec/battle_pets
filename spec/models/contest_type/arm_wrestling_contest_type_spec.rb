require 'rails_helper'

RSpec.describe ContestType::ArmWrestlingContestType do
  describe ".name" do
    subject { described_class.name } 

    it "is 'arm_wrestling'" do
      expect(subject).to eq('arm_wrestling')
    end
  end

  describe ".score_competitor" do
    let!(:pet) { double(PetApi::Pet, strength: 30, speed: 20, intelligence: 15) }
    subject { described_class.score_competitor(pet: pet) }

    it "computes a composite score" do
      computed_score = pet.strength * 3 + pet.speed * 2 + pet.intelligence
      expect(subject).to eq(computed_score)
    end
  end
end
