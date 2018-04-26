require 'rails_helper'

RSpec.describe ContestType::BeerDrinkingContestType do
  describe ".rounds" do
    it "is unlimited" do
     expect(described_class.rounds).to eq(-1)
    end
  end

  describe ".name" do
    it "is beer_drinking" do
      expect(described_class.name).to eq('beer_drinking')
    end
  end

  describe ".score_competitor" do
    let!(:strength) { 30 }
    let!(:integrity) { 30 }
    let!(:pet) { double(PetApi::Pet, strength: strength, integrity: integrity) }
    let!(:ibu) { 15 }
    let!(:abv) { 42 }
    let!(:beer) do
      {
        :name => "Dorée",
        :brewery => "Bières de Chimay ",
        :style => "Belgian Pale Ale",
        :abv => abv,
        :ibu => ibu
      }
    end
    let!(:beer_generator) { class_double(BeerGenerator, call: beer) }
    let!(:configured_class) { described_class.new(beer_generator: beer_generator) }

    subject { configured_class.score_competitor(pet: pet) }

    it "returns a composite value based on integrity and strength" do
      computed_score = beer[:abv] + 3 * beer[:ibu]
      expect(subject).to eq(computed_score)
    end
  end
end
