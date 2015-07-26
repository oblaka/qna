require 'rails_helper'

describe VotePolicy do
  let(:vote) { build :vote }
  let(:exist_vote) { create :vote }

  subject { described_class }

  permissions :good? do
    it 'allow vote for user who not voted yet' do
      expect(subject).to permit(vote.user, vote)
    end
    it 'deny vote for already voted user' do
      expect(subject).to_not permit(exist_vote.user, exist_vote)
    end
    it 'deny vote for author' do
      expect(subject).to_not permit(vote.votable.user, exist_vote)
    end
  end

  permissions :shit? do
    it 'allow vote for user who not voted yet' do
      expect(subject).to permit(vote.user, vote)
    end
    it 'deny vote for already voted user' do
      expect(subject).to_not permit(exist_vote.user, exist_vote)
    end
    it 'deny vote for author' do
      expect(subject).to_not permit(vote.votable.user, exist_vote)
    end
  end

  permissions :revoke? do
    it 'allow revoke for voter' do
      expect(subject).to permit(exist_vote.user, exist_vote)
    end
    it 'deny revoke vote for another user' do
      expect(subject).to_not permit(vote.user, vote)
    end
    it 'deny revoke vote for new vote' do
      expect(subject).to_not permit(vote.user, vote)
    end
  end
end
