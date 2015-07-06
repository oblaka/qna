require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question }
  it { should belong_to :question }
  it { should validate_presence_of :user }
  it { should belong_to :user }
  it { should validate_length_of(:body).is_at_least(17) }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  let(:question) { create(:question) }
  let!(:answer1) { create(:answer, question: question, best: false) }
  let!(:answer2) { create(:answer, question: question, best: true) }

  it_should_behave_like 'votable'

  describe 'is_solution' do
    it 'set answer #best to true' do
      answer1.is_solution
      expect(answer1.best).to eq true
    end

    it "set another answer question answers best to false" do
      answer1.is_solution
      answer2.reload
      expect(answer2.best).to eq false
    end
  end
end
