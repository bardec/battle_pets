class SingleRoundPlayService
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

    contest_type_class = contest_type_list_service.names_to_types_for_in_progress_contests[contest.contest_type]

    first_competitor_score = contest_type_class.score_competitor(pet: first_competitor_pet)
    second_competitor_score = contest_type_class.score_competitor(pet: second_competitor_pet)

    if first_competitor_score > second_competitor_score
      contest.first_competitor
    elsif second_competitor_score > first_competitor_score
      contest.second_competitor
    else
     [contest.first_competitor, contest.second_competitor].sample
    end
  end

  private
  attr_reader :get_pet_service, :contest_type_list_service
end
