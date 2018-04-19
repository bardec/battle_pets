class ContestCreationValidationService

  def self.call(contest_type:, first_competitor:, second_competitor:)
    new.call(
      contest_type: contest_type, 
      first_competitor: first_competitor, 
      second_competitor: second_competitor
    )
  end

  def initialize(
    get_pet_service: PetApi::GetPetService
  )
    @get_pet_service = get_pet_service
  end

  def call(contest_type:, first_competitor:, second_competitor:)
    @contest_type = contest_type
    @first_competitor = first_competitor
    @second_competitor = second_competitor

    return self unless contest_type_is_valid?
    return self unless both_competitors_are_valid?

    self
  end

  def success?
    contest_type_is_valid? && both_competitors_are_valid?
  end

  private
  attr_reader :get_pet_service, 
    :contest_type, 
    :first_competitor, 
    :second_competitor

  def contest_type_is_valid?
    @contest_type_valid ||= ContestType::BaseContestType
      .subclasses
      .map(&:name)
      .include?(contest_type)
  end

  def both_competitors_are_valid?
    @both_competitors_valid ||= get_pet_service.call(pet_id: first_competitor).success? &&
      get_pet_service.call(pet_id: second_competitor).success?
  end
end
