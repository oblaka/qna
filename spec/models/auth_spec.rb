require 'rails_helper'

RSpec.describe Auth, type: :model do
  it { should belong_to :user }
  it { should validate_uniqueness_of(:user_id).scoped_to([:provider, :uid]) }

  let!(:exist_auth) { create(:fb_auth) }
end
