require 'rails_helper'

RSpec.describe Comment, type: :model do

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least 7 }
  it { should validate_presence_of :commentable }
  it { should validate_presence_of :user }
  it { should belong_to :commentable }
  it { should belong_to :user }

end
