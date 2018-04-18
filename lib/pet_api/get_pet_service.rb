require 'json'

module PetApi
  class GetPetService
    attr_reader :success, :pet
    alias_method :success?, :success

    def self.call(pet_id:)
      new.call(pet_id: pet_id)
    end

    def call(pet_id:)
      pet_response = PetApi::Client.get(pet_id: pet_id)

      if pet_response.success?
        pet_attributes = JSON.parse(pet_response.body)
        @pet = Pet.new(attrs: pet_attributes)
        @success = true
      else
        @pet = nil
        @success = false
      end

      self
    end
  end
end
