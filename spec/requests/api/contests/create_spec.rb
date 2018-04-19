require 'rails_helper'

RSpec.describe "Contests creation" do
  describe "POST /contests" do
    let!(:first_competitor) { SecureRandom.uuid }
    let!(:second_competitor) { SecureRandom.uuid }
    let!(:contest_type) { ContestType::PotatoRacingContestType.name }
    let!(:params) do
      {
        contest: {
          first_competitor: first_competitor,
          second_competitor: second_competitor,
          type: contest_type
        }
      }
    end

    context "valid pet ids" do
      around(:each) do |example| 
        VCR.use_cassette(
          "found_pet", 
          allow_playback_repeats: true, 
          match_requests_on: [:any_pet_matcher], 
          &example
        ) 
      end

      it "returns accepted" do
        post '/contests', params: params

        expect(response).to have_http_status(:accepted)
      end

      it "returns a body" do
        post '/contests', params: params

        expect(parsed_body["contest"]["id"]).to be_present
        expect(parsed_body["contest"]["type"]).to eq(contest_type)
        expect(parsed_body["contest"]["first_competitor"]).to eq(first_competitor)
        expect(parsed_body["contest"]["second_competitor"]).to eq(second_competitor)
        expect(parsed_body["contest"]["status"]).to eq(Contest::Status::IN_PROGRESS)
        expect(parsed_body["contest"]["winner"]).to be_nil
        expect(parsed_body["contest"]["completed_at"]).to be_nil
      end
    end

    context "missing pet ids" do
      around(:each) do |example| 
        VCR.use_cassette(
          "missing_pet", 
          allow_playback_repeats: true, 
          match_requests_on: [:any_pet_matcher], 
          &example
        ) 
      end
      
      it "returns 422" do
        post '/contests', params: params

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns errors" do
        post '/contests', params: params

        expect(parsed_body).to have_key("errors")
      end
    end
  end
end
