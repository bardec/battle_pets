class ContestInitializationService
  attr_reader :contest

  def self.call(contest_type:, first_competitor:, second_competitor:)
    new.call(
      contest_type: contest_type, 
      first_competitor: first_competitor, 
      second_competitor: second_competitor
    )
  end

  def initialize(
    contest_creation_validation_service: ContestCreationValidationService,
    contest_creation_service: ContestCreationService
  )
    @contest_creation_validation_service = contest_creation_validation_service
    @contest_creation_service = contest_creation_service
  end

  def call(contest_type:, first_competitor:, second_competitor:)
    @contest_type = contest_type
    @first_competitor = first_competitor
    @second_competitor = second_competitor

    return self unless contest_creation_validation_result.success?
    return self unless contest_creation_result.success?

    @contest = contest_creation_result.contest

    self
  end

  def success?
    contest_creation_validation_result.success? &&
      contest_creation_result.success?
  end

  def errors
    contest_creation_validation_result.errors
  end

  private
  attr_reader :contest_creation_validation_service,
    :contest_creation_service,
    :contest_type, 
    :first_competitor, 
    :second_competitor

  def contest_creation_validation_result
    @contest_creation_validation_result ||= contest_creation_validation_service.call(
      contest_type: contest_type,
      first_competitor: first_competitor,
      second_competitor: second_competitor
    )
  end

  def contest_creation_result
    @contest_creation_result ||= contest_creation_service.call(
      contest_type: contest_type,
      first_competitor: first_competitor,
      second_competitor: second_competitor
    )
  end
end
