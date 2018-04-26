module ContestType
  class BeerDrinkingContestType < BaseContestType
    attr_reader :beer

    def self.name
      'beer_drinking'
    end

    def self.rounds
      -1
    end

    def self.score_competitor(pet:)
      new.score_competitor(pet: pet)
    end

    def initialize(beer_generator: BeerGenerator)
      @beer = beer_generator.call
    end

    def score_competitor(pet:)
      beer[:abv] + 3 * beer[:ibu]
    end
  end
end
