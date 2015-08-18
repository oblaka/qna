require 'rails_helper'

describe UserPolicy do

  let(:user) { create :user }
  let(:another_user) { create :user }

  subject { described_class }

  permissions :me? do
    it 'grants access if user is self' do
      expect(subject).to permit(user, user)
    end
    it 'prevents access if user is not self' do
      expect(subject).to_not permit(user, another_user)
    end
  end

end
