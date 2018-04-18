class ContestCreationService
  attr_reader :contest

  def self.call(contest_type:, first_competitor:, second_competitor:)
    new.call(
      contest_type: contest_type,
      first_competitor: first_competitor,
      second_competitor: second_competitor
    )
  end

  def initialize(contest_repo: Contest)
    @contest_repo = contest_repo
  end

  def call(contest_type:, first_competitor:, second_competitor:)
    @contest = contest_repo.create(
      contest_type: contest_type,
      first_competitor: first_competitor,
      second_competitor: second_competitor,
      status: Contest::Status::IN_PROGRESS
    )

    self
  end

  def success?
    self.contest.persisted?
  end
  
  private
  attr_reader :contest_repo, :contest_type, :first_competitor, :second_competitor

end
