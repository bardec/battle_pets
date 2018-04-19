class ContestPlayJob < ApplicationJob
  queue_as :default
  attr_writer :contest_play_service

  def self.enqueue(contest:)
    perform_later(contest_id: contest.id)
  end

  def perform(contest_id:)
    contest_play_service.call(contest_id: contest_id)
  end

  def contest_play_service
    @contest_play_service ||= ContestPlayService
  end
end
