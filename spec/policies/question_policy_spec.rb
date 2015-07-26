require 'rails_helper'

describe QuestionPolicy do
  let(:user) { create :user }
  let(:unconfirmed_user) { create :user, confirmed_at: nil }
  let(:question) { create :question }
  let(:vote) { build :vote, votable: question }
  let(:exist_vote) { create :vote, votable: question }

  subject { described_class }

  permissions :create? do
    it 'grants access if user is owner' do
      expect(subject).to permit(user)
    end
    it 'prevents access if user is not owner' do
      expect(subject).to_not permit(unconfirmed_user)
    end
  end

  permissions :update? do
    it 'grants access if user is owner' do
      expect(subject).to permit(question.user, question)
    end
    it 'prevents access if user is not owner' do
      expect(subject).to_not permit(user, question)
    end
  end

  permissions :destroy? do
    it 'grants access if user is owner' do
      expect(subject).to permit(question.user, question)
    end
    it 'prevents access if user is not owner' do
      expect(subject).to_not permit(user, question)
    end
  end

  permissions :good? do
    it 'allow vote for user who not voted yet' do
      expect(subject).to permit(user, question)
    end
    it 'deny vote for already voted user' do
      expect(subject).to_not permit(exist_vote.user, question)
    end
    it 'deny vote for author' do
      expect(subject).to_not permit(vote.votable.user, question)
    end
  end

  permissions :shit? do
    it 'allow vote for user who not voted yet' do
      expect(subject).to permit(user, question)
    end
    it 'deny vote for already voted user' do
      expect(subject).to_not permit(exist_vote.user, question)
    end
    it 'deny vote for author' do
      expect(subject).to_not permit(vote.votable.user, question)
    end
  end

  permissions :revoke? do
    it 'allow revoke for voter' do
      expect(subject).to permit(exist_vote.user, question)
    end
    it 'deny revoke vote for another user' do
      expect(subject).to_not permit(user, question)
    end
    it 'deny revoke vote for new vote' do
      expect(subject).to_not permit(vote.user, question)
    end
  end
end
