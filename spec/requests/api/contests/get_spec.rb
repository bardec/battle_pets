require 'rails_helper'

RSpec.describe '/contests/id' do
  context "id does not exist" do
    let!(:id) { 5000000 }

    it 'returns a 404' do
      get "/contests/#{id}"
      expect(response).to have_http_status(:not_found)
    end
  end

  context "id exists" do
    let!(:contest) do
      ContestCreationService.call(
        contest_type: 'potato_racing',
        first_competitor: SecureRandom.uuid,
        second_competitor: SecureRandom.uuid
      ).contest
    end
    let!(:id) { contest.id }

    it "returns a 200" do
      get "/contests/#{id}"
      expect(response).to have_http_status(:ok)
    end

    it "returns a serialized contest" do
      get "/contests/#{id}"

      expect(parsed_body["contest"]["id"]).to be_present
      expect(parsed_body["contest"]["type"]).to eq(contest.contest_type)
      expect(parsed_body["contest"]["first_competitor"]).to eq(contest.first_competitor)
      expect(parsed_body["contest"]["second_competitor"]).to eq(contest.second_competitor)
      expect(parsed_body["contest"]["status"]).to eq(Contest::Status::IN_PROGRESS)
      expect(parsed_body["contest"]["winner"]).to be_nil
      expect(parsed_body["contest"]["completed_at"]).to be_nil
    end
  end
end
