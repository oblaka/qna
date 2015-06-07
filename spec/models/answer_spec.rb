require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question }
  it { should belong_to :question }
  it { should validate_presence_of :user }
  it { should belong_to :user }
  it { should validate_length_of(:body).is_at_least(17) }
end