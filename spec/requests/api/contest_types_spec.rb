require 'rails_helper'

RSpec.describe 'Contest Types' do
  describe "/contest_types" do
    it "returns a list of all allowed contest_types" do
      get '/contest_types'

      expect(response).to have_http_status(:ok)
      expect(parsed_body).to eq("contest_types" => ContestTypeListService.names_to_types_for_new_contests.keys)
    end
  end
end
