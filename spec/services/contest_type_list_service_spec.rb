require 'rails_helper'

RSpec.describe ContestTypeListService do
  let!(:config) { {"black_listed_names" => ["arm_wrestling"]} }
  let!(:configured_service) { described_class.new(config: config) }

  describe "#names_to_types_for_new_contests" do
    subject { configured_service.names_to_types_for_new_contests }

    it "returns a hash of names to classes" do
      expect(subject).to eq("potato_racing" => ContestType::PotatoRacingContestType)
    end

    it "not return keys in the black_list" do
      expect(subject.values).to_not include(ContestType::ArmWrestlingContestType)
      expect(subject).to_not have_key(ContestType::ArmWrestlingContestType.name)
    end
  end

  describe "#names_to_types_for_in_progress_contests" do
    subject { configured_service.names_to_types_for_in_progress_contests }

    it "returns a hash of names to classes ignoring the blacklist" do
      expect(subject).to eq(
        "potato_racing" => ContestType::PotatoRacingContestType,
        "arm_wrestling" => ContestType::ArmWrestlingContestType
      )
    end
  end
end
