class ContestPlayService
  def self.call(contest_id:)
    new.call(contest_id: contest_id)
  end

  def initialize(
    get_pet_service: PetApi::GetPetService, 
    contest_repo: Contest,
    complete_contest_transition_service: CompleteContestTransitionService
  )
    @get_pet_service = get_pet_service
    @contest_repo = contest_repo
    @complete_contest_transition_service = complete_contest_transition_service
  end

  def call(contest_id:)
    contest = contest_repo.find(contest_id)
    first_competitor_pet = get_pet_service.call(pet_id: contest.first_competitor).pet
    second_competitor_pet = get_pet_service.call(pet_id: contest.second_competitor).pet
    
    contest_type_class = ContestType::BaseContestType.subclasses.detect { |klass| klass.name == contest.contest_type }

    first_competitor_score = contest_type_class.score_competitor(pet: first_competitor_pet)
    second_competitor_score = contest_type_class.score_competitor(pet: second_competitor_pet)

    if first_competitor_score > second_competitor_score
      complete_contest_transition_service.call(winner_id: contest.first_competitor, contest: contest)
    elsif second_competitor_score > first_competitor_score
      complete_contest_transition_service.call(winner_id: contest.second_competitor, contest: contest)
    else
      winner_id = [contest.first_competitor, contest.second_competitor].sample
      complete_contest_transition_service.call(winner_id: winner_id, contest: contest)
    end

    self
  end

  private
  attr_reader :get_pet_service,
    :contest_repo,
    :complete_contest_transition_service
end
