module ContestType
  class ArmWrestlingContestType < BaseContestType
    def self.name
      'arm_wrestling'
    end

    def self.score_competitor(pet:)
      pet.strength * 3 + pet.speed * 2 + pet.intelligence
    end
  end
end
