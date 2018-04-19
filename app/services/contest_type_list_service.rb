class ContestTypeListService
  def self.names_to_types_for_new_contests 
    new.names_to_types_for_new_contests
  end

  def self.names_to_types_for_in_progress_contests
    new.names_to_types_for_in_progress_contests
  end

  def initialize(config: Rails.application.config_for(:contest_type))
    @black_listed_names = config.fetch("black_listed_names", [])
  end

  def names_to_types_for_new_contests
    names_to_types_for_in_progress_contests.except(*black_listed_names)
  end

  def names_to_types_for_in_progress_contests
    ContestType::BaseContestType.subclasses.index_by(&:name)
  end

  private
  attr_reader :black_listed_names
end
