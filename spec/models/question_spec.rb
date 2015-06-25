require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_length_of(:title).is_at_least(4)  }
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should have_many :answers }
  it { should validate_presence_of :user }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many :votes }
  it { should accept_nested_attributes_for :attachments }

  it_should_behave_like 'votable'

end
