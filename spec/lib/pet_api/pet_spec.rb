require 'spec_helper'

RSpec.describe PetApi::Pet do
  let!(:pet_attributes) do
    {
      "id" => "d44c512d-65f2-4173-a7aa-a1ebc8cc52d6",
      "name" => "Fluffy",
      "strength" => 12,
      "intelligence" => 22,
      "speed" => 21,
      "integrity" => 66,
    } # JSON.parse returns a string
  end
  subject { described_class.new(attrs: pet_attributes) }

  context "getters" do
    it "returns the id" do
      expect(subject.id).to eq(pet_attributes.fetch("id"))
    end

    it "returns the name" do
      expect(subject.name).to eq(pet_attributes.fetch("name"))
    end

    it "returns the strength" do
      expect(subject.strength).to eq(pet_attributes.fetch("strength").to_i)
    end

    it "returns the intelligence" do
      expect(subject.intelligence).to eq(pet_attributes.fetch("intelligence").to_i)
    end

    it "returns the speed" do
      expect(subject.speed).to eq(pet_attributes.fetch("speed").to_i)
    end

    it "returns the integrity" do
      expect(subject.integrity).to eq(pet_attributes.fetch("integrity").to_i)
    end
  end
end
