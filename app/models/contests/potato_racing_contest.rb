module Contests
  class PotatoRacingContest < BaseContest
    def self.name 
      'potato_racing'
    end

    def self.score_competitor(pet:)
      new.score_competitor(pet: pet)
    end

    def initialize(rng: Random.new)
      @rng = rng
    end

    def score_competitor(pet:)
      rng.rand(pet.intelligence) + pet.speed
    end

    private
    attr_reader :rng
  end
end
