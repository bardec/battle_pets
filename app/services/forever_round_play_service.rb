class ForeverRoundPlayService
  def self.call(contest:)
    new.call(contest: contest)
  end

  def initialize(
    get_pet_service: PetApi::GetPetService,
    contest_type_list_service: ContestTypeListService
  )
    @get_pet_service = get_pet_service
    @contest_type_list_service = contest_type_list_service
  end

  def call(contest:)
    first_competitor_pet = get_pet_service.call(pet_id: contest.first_competitor).pet
    second_competitor_pet = get_pet_service.call(pet_id: contest.second_competitor).pet

    first_competitor_health = compute_initial_health(first_competitor_pet)
    second_competitor_health = compute_initial_health(second_competitor_pet)

    contest_type_class = contest_type_list_service.names_to_types_for_in_progress_contests[contest.contest_type]

    loop do
      random_beer_contest_type = contest_type_class.new

      first_competitor_health -= random_beer_contest_type.score_competitor(pet: first_competitor_pet)
      return second_competitor.id if first_competitor_health <= 0

      second_competitor_health -= random_beer_contest_type.score_competitor(pet: second_competitor_pet)
      return first_competitor_pet.id if second_competitor_health <= 0
    end
  end

  private
  attr_reader :get_pet_service, :contest_type_list_service

  def compute_initial_health(pet)
    pet.strength * 30 + pet.integrity * 10
  end
end
