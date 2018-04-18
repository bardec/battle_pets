require 'rails_helper'

RSpec.describe Contest, type: :model do
  let!(:contest) do
    Contest.new(
      first_competitor: first_competitor, 
      second_competitor: second_competitor, 
      contest_type: contest_type,
      status: status,
      winner: winner,
      completed_at: completed_at
    )
  end
  let!(:first_competitor) { SecureRandom.uuid }
  let!(:second_competitor) { SecureRandom.uuid }
  let!(:contest_type) { "Type" }
  let!(:status) { Contest::Status::COMPLETED }
  let!(:winner) { first_competitor }
  let!(:completed_at) { 1.day.ago } 

  context "validations" do
    context "first_competitor is nil" do
      let!(:first_competitor) { nil }

      it "is invalid" do
        expect do
          contest.save!
        end.to raise_exception(ActiveRecord::RecordInvalid, /First competitor can't be blank/)
      end
    end

    context "second_competitor is nil" do
      let!(:second_competitor) { nil }

      it "is invalid" do
        expect do
          contest.save!
        end.to raise_exception(ActiveRecord::RecordInvalid, /Second competitor can't be blank/)
      end
    end

    context "contest_type is nil" do
      let!(:contest_type) { nil }

      it "is invalid" do
        expect do
          contest.save!
        end.to raise_exception(ActiveRecord::RecordInvalid, /Contest type can't be blank/)
      end
    end

    context "status" do
      context "is nil" do
        let!(:status) { nil }

        it "is invalid" do
          expect do
            contest.save!
          end.to raise_exception(ActiveRecord::RecordInvalid, /Status can't be blank/)
        end
      end

      context "is anything else" do
        let!(:status) { "invalid_status" }

        it "is invalid" do
          expect do
            contest.save!
          end.to raise_exception(ActiveRecord::RecordInvalid, /Status is not included in the list/)
        end
      end
    end

    context "completed game" do
      let!(:status) { Contest::Status::COMPLETED }

      context "without winner" do
        let!(:winner) { nil } 

        it "is invalid" do
          expect do
            contest.save!
          end.to raise_exception(ActiveRecord::RecordInvalid, /A completed game must have completed_at and a winner set!/)
        end
      end

      context "without completed_at" do
        let!(:completed_at) { nil } 

        it "is invalid" do
          expect do
            contest.save!
          end.to raise_exception(ActiveRecord::RecordInvalid, /A completed game must have completed_at and a winner set!/)
        end
      end
    end

    context "in_progress game" do
      let!(:status) { Contest::Status::IN_PROGRESS }
      let!(:completed_at) { nil }
      let!(:winner) { nil }

      context "with winner" do
        let!(:winner) { SecureRandom.uuid } 

        it "is invalid" do
          expect do
            contest.save!
          end.to raise_exception(ActiveRecord::RecordInvalid, /An in_progress game cannot have a winner or a completed_at!/)
        end
      end

      context "with completed_at" do
        let!(:completed_at) { 1.day.ago } 

        it "is invalid" do
          expect do
            contest.save!
          end.to raise_exception(ActiveRecord::RecordInvalid, /An in_progress game cannot have a winner or a completed_at!/)
        end
      end
    end
  end
end
