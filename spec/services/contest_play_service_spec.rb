require 'rails_helper' 

RSpec.describe ContestPlayService do
  let!(:contest_id) { 5 }
  let!(:contest_type_class) { ContestType::PotatoRacingContestType }
  let!(:contest_type) { contest_type_class.name }
  let!(:first_competitor) { SecureRandom.uuid }
  let!(:second_competitor) { SecureRandom.uuid }
  let!(:first_competitor_score) { 20 }
  let!(:second_competitor_score) { 10 }

  let!(:first_competitor_pet) { instance_double(PetApi::Pet, id: first_competitor) } 
  let!(:second_competitor_pet) { instance_double(PetApi::Pet, id: second_competitor) } 
  let!(:first_competitor_pet_result) { instance_double(PetApi::GetPetService, success?: true, pet: first_competitor_pet) }
  let!(:second_competitor_pet_result) { instance_double(PetApi::GetPetService, success?: true, pet: second_competitor_pet) }
  let!(:get_pet_service) { class_double(PetApi::GetPetService, call: nil) }

  let!(:contest_repo) { class_double(Contest, find: contest) }
  let!(:contest) do 
    instance_double(
      Contest, 
      id: contest_id,
      first_competitor: first_competitor, 
      second_competitor: second_competitor,
      contest_type: contest_type
    )
  end

  let!(:complete_contest_transition_service) { class_double(CompleteContestTransitionService, call: nil) }

  let!(:configured_service) do
    described_class.new(
      get_pet_service: get_pet_service,
      contest_repo: contest_repo,
      complete_contest_transition_service: complete_contest_transition_service
    )
  end

  describe "#call" do
    subject { configured_service.call(contest_id: contest_id) }
    before do
      allow(get_pet_service).to receive(:call).with(pet_id: first_competitor).and_return(first_competitor_pet_result)
      allow(get_pet_service).to receive(:call).with(pet_id: second_competitor).and_return(second_competitor_pet_result)

      allow(contest_type_class).to receive(:score_competitor).with(pet: first_competitor_pet).and_return(first_competitor_score)
      allow(contest_type_class).to receive(:score_competitor).with(pet: second_competitor_pet).and_return(second_competitor_score)
    end

    it "uses the correct contest_type class to score the contest" do
      expect(contest_type_class).to receive(:score_competitor).with(pet: first_competitor_pet)
      expect(contest_type_class).to receive(:score_competitor).with(pet: second_competitor_pet)
      subject
    end
    
    context "when the first_competitor gets a higher score" do
      let!(:first_competitor_score) { 20 }
      let!(:second_competitor_score) { 10 }

      it "calls the CompleteContestTransitionService" do
        expect(complete_contest_transition_service).to receive(:call).with(winner_id: first_competitor, contest: contest)
        subject
      end
    end

    context "when the second_competitor gets the higher score" do
      let!(:first_competitor_score) { 10 }
      let!(:second_competitor_score) { 20 }

      it "calls the CompleteContestTransitionService" do
        expect(complete_contest_transition_service).to receive(:call).with(winner_id: second_competitor, contest: contest)
        subject
      end
    end

    context "when the competitors tie" do
      let!(:first_competitor_score) { 20 }
      let!(:second_competitor_score) { 20 }

      it "uses Array#sample to pick a winner" do
        allow_any_instance_of(Array).to receive(:sample).and_return(second_competitor)
        expect(complete_contest_transition_service).to receive(:call).with(winner_id: second_competitor, contest: contest)
        subject
      end
    end
  end
end
