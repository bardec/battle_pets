class CompleteContestTransitionService
  attr_reader :success, :contest
  alias_method :success?, :success

  def self.call(winner_id:, contest:)
    new.call(winner_id: winner_id, contest: contest)
  end

  def initialize(time: Time)
    @time = time
  end

  def call(winner_id:, contest:)
    was_successfully_updated = contest.update(
      status: Contest::Status::COMPLETED,
      winner: winner_id,
      completed_at: time.now
    )

    if was_successfully_updated
      @success = true
      @contest = contest
    else
      @success = false
    end

    self
  end

  private
  attr_reader :time
end
