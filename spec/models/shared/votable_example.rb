require 'rails_helper'

shared_examples 'votable' do

  it { should have_many(:votes).dependent(:destroy) }

  let(:votable) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }
  let(:users) { create_list(:user, 3) }

  describe '#vote_for' do
    it 'find or initialize vote for user' do
      vote = votable.vote_for user
      expect(vote.voter).to eq(user)
    end
  end

  describe '#rating' do
    it 'return votable rating' do
      users.each do |u|
        vote = votable.vote_for u
        vote.increase
      end
      expect(votable.rating).to eq(3)
    end
  end

end
