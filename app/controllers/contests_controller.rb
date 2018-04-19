class ContestsController < ApplicationController
  def create
    result = ContestInitializationService.call(
      contest_type: allowed_contest_params[:type],
      first_competitor: allowed_contest_params[:first_competitor],
      second_competitor: allowed_contest_params[:second_competitor]
    )
    if result.success?
      render json: result.contest, status: :accepted
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end
  
  private

  def allowed_contest_params
    params.require(:contest).permit(:type, :first_competitor, :second_competitor)
  end

  def contains_all_params?
    allowed_contest_params[:type] &&
      allowed_contest_params[:first_competitor] &&
      allowed_contest_params[:second_competitor]
  end
end
