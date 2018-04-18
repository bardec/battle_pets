class Contest < ApplicationRecord
  module Status
    ALL = [
      IN_PROGRESS = 'in_progress'.freeze,
      COMPLETED = 'completed'.freeze,
    ].freeze
  end

  validates :first_competitor, presence: true
  validates :second_competitor, presence: true
  validates :contest_type, presence: true
  validates :status, presence: true, inclusion: Status::ALL
  validate :completed_game_must_have_winner_and_completed_at, if: -> { status == Status::COMPLETED }
  validate :in_progress_game_must_not_have_winner_or_completed_at, if: -> { status == Status::IN_PROGRESS }

  private

  module ErrorMessage
    ALL = [
      INVALID_COMPLETED_STATE = "A completed game must have completed_at and a winner set!".freeze,
      INVALID_IN_PROGRESS_STATE = "An in_progress game cannot have a winner or a completed_at!".freeze,
    ].freeze
  end

  def completed_game_must_have_winner_and_completed_at
    return if completed_at.present? && winner.present?
    errors.add(:base, ErrorMessage::INVALID_COMPLETED_STATE)
  end

  def in_progress_game_must_not_have_winner_or_completed_at
    return if completed_at.nil? && winner.nil?
    errors.add(:base, ErrorMessage::INVALID_IN_PROGRESS_STATE)
  end
end
