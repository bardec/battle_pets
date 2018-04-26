class ContestPlayService
  def self.call(contest_id:)
    new.call(contest_id: contest_id)
  end

  def initialize(
    contest_repo: Contest,
    complete_contest_transition_service: CompleteContestTransitionService,
    contest_type_list_service: ContestTypeListService,
    single_round_play_service: SingleRoundPlayService,
    forever_round_play_service: ForeverRoundPlayService
  )
    @contest_repo = contest_repo
    @contest_type_list_service = contest_type_list_service
    @complete_contest_transition_service = complete_contest_transition_service
    @single_round_play_service = single_round_play_service
    @forever_round_play_service = forever_round_play_service
  end

  def call(contest_id:)
    contest = contest_repo.find(contest_id)

    contest_type = contest_type_list_service.names_to_types_for_in_progress_contests[contest.contest_type]

    winner_id = if contest_type.rounds == -1
      forever_round_play_service.call(contest: contest)
    elsif contest_type.rounds == 1
      single_round_play_service.call(contest: contest)
    end

    complete_contest_transition_service.call(winner_id: winner_id, contest: contest)
    self
  end

  private
  attr_reader :contest_repo,
    :complete_contest_transition_service,
    :single_round_play_service,
    :forever_round_play_service,
    :contest_type_list_service
end
