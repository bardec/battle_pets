class ContestTypesController < ApplicationController
  def index
    contest_type_names = ContestTypeListService.names_to_types_for_new_contests.keys
    render json: {
      "contest_types" => contest_type_names
    }
  end
end
