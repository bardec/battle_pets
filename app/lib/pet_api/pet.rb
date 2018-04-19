module PetApi
  class Pet
    attr_reader :id,
      :name,
      :strength,
      :intelligence,
      :speed,
      :integrity

    def initialize(attrs:)
      @id = attrs.fetch("id")
      @name = attrs.fetch("name")
      @strength = attrs.fetch("strength").to_i
      @intelligence = attrs.fetch("intelligence").to_i
      @speed = attrs.fetch("speed").to_i
      @integrity = attrs.fetch("integrity").to_i
    end
  end
end
