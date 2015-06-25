require 'rails_helper'

RSpec.describe Vote, type: :model do

  let(:question) { create(:question) }
  let(:vote) { create(:vote, votable: question) }
  let(:overall) { create(:vote, votable: question, voter: question, rate: 3) }

  describe '#increase' do
    context 'vote rate is less then 1' do
      before do
        vote
        overall
      end
      it "increase vote" do
        expect { vote.increase }.to change(vote, :rate).by 1
      end
      it "increase votable rating" do
        vote.increase
        expect { overall.reload }.to change(overall, :rate).by 1
      end
      it "returns true" do
        expect( vote.increase ).to be true
      end
    end

    context 'vote rate is 1 or more' do
      let(:vote) { create(:vote, rate: 1) }
      it "not increase vote" do
        expect { vote.increase }.to_not change(vote, :rate)
      end
      it "not increase votable rating" do
        vote.increase
        expect { overall.reload }.to_not change(overall, :rate)
      end
      it "return false" do
        expect( vote.increase ).to be false
      end
    end
  end

  describe '#decrease' do
    context 'vote rate is more then -1' do
      before do
        vote
        overall
      end
      it "decrease vote" do
        expect { vote.decrease }.to change(vote, :rate).by -1
      end
      it "decrease votable rating" do
        vote.decrease
        expect { overall.reload }.to change(overall, :rate).by -1
      end
      it "returns true" do
        expect( vote.decrease ).to be true
      end
    end

    context 'vote rate is -1' do
      let(:vote) { create(:vote, rate: -1) }
      it "not increase vote" do
        expect { vote.decrease }.to_not change(vote, :rate)
      end
      it "not increase votable rating" do
        vote.decrease
        expect { overall.reload }.to_not change(overall, :rate)
      end
      it "return false" do
        expect( vote.decrease ).to be false
      end
    end
  end

  describe 'rating' do
    it "returns overall votes summ" do
      overall
      expect(vote.rating).to eq(overall.rate)
    end
  end
end
