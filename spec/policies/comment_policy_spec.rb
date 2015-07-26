require 'rails_helper'

describe CommentPolicy do
  let(:user) { create :user }
  let(:unconfirmed_user) { create :user, confirmed_at: nil }

  subject { described_class }

  permissions :create? do
    it 'grants access if user is confirmed' do
      expect(subject).to permit(user)
    end
    it 'prevents access if user is not confirmed' do
      expect(subject).to_not permit(unconfirmed_user)
    end
  end
end
