class BeerGenerator
  def self.call
    new.call
  end

  attr_reader :beers

  def call
    beers.sample
  end

  def initialize
    @beers = [
      {
        "name": "Dorée",
        "brewery": "Bières de Chimay ",
        "style": "Belgian Pale Ale",
        "abv": 4.8,
        "ibu": 16
      },
      {
        "name": "Tart 'N Juicy Sour IPA",
        "brewery": "Epic Brewing Company",
        "style": "IPA - American",
        "abv": 5.0,
        "ibu": 60
      },
      {
        "name": "Liliko'i Kepolo",
        "brewery": "Avery Brewing Company",
        "style": "Witbier",
        "abv": 5.4,
        "ibu": 10
      },
      {
        "name": "Rodenbach Grand Cru",
        "brewery": "Brouwerij Rodenbach",
        "style": "Sour - Flanders Red Ale",
        "abv": 6.0,
        "ibu": 35
      },
      {
        "name": "Citradelic: Tangerine IPA",
        "brewery": "New Belgium Brewing Company",
        "style": "IPA - American",
        "abv": 6.0,
        "ibu": 50
      },
      {
        "name": "St. Lupulin",
        "brewery": "Odell Brewing Company",
        "style": "Pale Ale - American",
        "abv": 6.5,
        "ibu": 46
      },
      {
        "name": "Dead Guy Ale",
        "brewery": "Rogue Ales",
        "style": "Maibock / Helles Bock",
        "abv": 6.8,
        "ibu": 40
      },
      {
        "name": "Union Jack IPA",
        "brewery": "Firestone Walker Brewing Company",
        "style": "IPA - American",
        "abv": 7.5,
        "ibu": 70
      },
      {
        "name": "Cinq Cents",
        "brewery": "Bières de Chimay ",
        "style": "Belgian Tripel",
        "abv": 8.0,
        "ibu": 38
      },
      {
        "name": "Hog Heaven",
        "brewery": "Avery Brewing Company",
        "style": "IPA - Imperial / Double",
        "abv": 9.2,
        "ibu": 104
      },
      {
        "name": "Sour Monkey",
        "brewery": "Victory Brewing Company",
        "style": "American Wild Ale",
        "abv": 9.5,
        "ibu": 25
      },
      {
        "name": "Double Jack",
        "brewery": "Firestone Walker Brewing Company",
        "style": "IPA - Imperial / Double",
        "abv": 9.5,
        "ibu": 85
      }
    ]
  end
end
