require 'rails_helper'

shared_examples 'commentable' do
  it { should have_many(:comments).dependent(:delete_all) }

  let(:commentable) { create(described_class.to_s.underscore.to_sym) }
  let(:user) { create(:user) }
end
