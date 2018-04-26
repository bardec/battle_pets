module ContestType
  class BaseContestType

    def self.rounds
      1
    end

    def self.name
      raise NotImplementedError
    end

    def self.score_competitor(pet:)
      raise NotImplementedError
    end
  end
end
