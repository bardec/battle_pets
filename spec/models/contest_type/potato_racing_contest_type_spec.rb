require 'rails_helper'

RSpec.describe ContestType::PotatoRacingContestType do
  context ".name" do
    subject { described_class.name }

    it "is 'potato_racing'" do
      expect(subject).to eq('potato_racing')
    end
  end

  context "#score_competitor" do
    let!(:random_number) { pet.intelligence - 2 }
    let!(:rng) { double(Random, rand: random_number) }
    let!(:pet) { double(PetApi::Pet, intelligence: 25, speed: 50) }
    let!(:configured_contest) { described_class.new(rng: rng) }

    subject { configured_contest.score_competitor(pet: pet) }

    it "is computed based on randomness, intelligence and speed" do
      expect(rng).to receive(:rand).with(pet.intelligence)
      expect(subject).to eq(random_number + pet.speed)
    end
  end
end
