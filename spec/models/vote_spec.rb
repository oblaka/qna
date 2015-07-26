require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_numericality_of(:rate) }
  it { should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type]) }
  it { is_expected.to callback(:cast).after(:create) }
  it { is_expected.to callback(:revoke).before(:destroy) }
  it { should delegate_method(:rating).to(:votable) }

  let(:question) { create(:question) }
  let!(:exist_vote) { create(:vote, votable: question) }

  describe '#create' do
    context 'good vote' do
      it 'increase question rating' do
        expect { create(:vote, votable: question, rate: 1) }.to change(question, :rating).by 1
      end
    end
    context 'shit vote' do
      it 'decrease question rating' do
        expect { create(:vote, votable: question, rate: -1) }.to change(question, :rating).by -1
      end
    end
  end

  describe '#destroy' do
    context 'good vote' do
      let!(:vote) { create(:vote, votable: question, rate: 1) }
      it 'decrease question rating' do
        expect { vote.destroy }.to change(question, :rating).by -1
      end
    end
    context 'shit vote' do
      let!(:vote) { create(:vote, votable: question, rate: -1) }
      it 'increase question rating' do
        expect { vote.destroy }.to change(question, :rating).by 1
      end
    end
  end
end
