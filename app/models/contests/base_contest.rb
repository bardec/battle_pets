module Contests
  class BaseContest
    def self.name
      raise NotImplementedError
    end

    def self.score_competitor(pet:)
      raise NotImplementedError
    end
  end
end
