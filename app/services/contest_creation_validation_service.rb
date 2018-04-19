class ContestCreationValidationService
  attr_reader :errors 
  def self.call(contest_type:, first_competitor:, second_competitor:)
    new.call(
      contest_type: contest_type, 
      first_competitor: first_competitor, 
      second_competitor: second_competitor
    )
  end

  def initialize(
    get_pet_service: PetApi::GetPetService,
    contest_type_list_service: ContestTypeListService
  )
    @get_pet_service = get_pet_service
    @contest_type_list_service = contest_type_list_service
    @errors = []
  end

  def call(contest_type:, first_competitor:, second_competitor:)
    @contest_type = contest_type
    @first_competitor = first_competitor
    @second_competitor = second_competitor

    if !all_params_are_present?
      @errors << "first_competitor, second_competitor, and type must be present"
      return self
    end

    if !contest_type_is_valid?
      @errors << "contest_type: '#{contest_type}' does not exist"
    end

    if !first_competitor_exists?
      @errors << "first_competitor: '#{first_competitor}' does not exist"
    end

    if !second_competitor_exists?
      @errors << "second_competitor: '#{second_competitor}' does not exist"
    end

    self
  end

  def success?
   all_params_are_present? && contest_type_is_valid? && first_competitor_exists? && second_competitor_exists?
  end

  private
  attr_reader :get_pet_service, 
    :contest_type_list_service,
    :contest_type, 
    :first_competitor, 
    :second_competitor

  def all_params_are_present?
    @all_params_are_present ||= contest_type.present? && 
      first_competitor.present? && 
      second_competitor.present?
  end

  def contest_type_is_valid?
    @contest_type_valid ||= contest_type_list_service
      .names_to_types_for_new_contests
      .include?(contest_type)
  end

  def first_competitor_exists?
    @first_competitor_valid = competitor_exists?(first_competitor)
  end

  def second_competitor_exists?
    @second_competitor_valid = competitor_exists?(second_competitor)
  end

  def competitor_exists?(pet_id)
    get_pet_service.call(pet_id: pet_id).success?
  end
end
