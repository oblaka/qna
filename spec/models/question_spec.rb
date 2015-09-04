require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_length_of(:title).is_at_least(4) }
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should have_many :answers }
  it { should validate_presence_of :user }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many :subscriptions }
  it { should have_many :votes }
  it { should accept_nested_attributes_for :attachments }

  it_should_behave_like 'commentable'
  it_should_behave_like 'votable'

  let(:user) { create :user }
  let(:question) { create :question }
  let(:user_question) { create :question, user: user }
  let(:subscription) { create :subscription }

  describe 'create' do
    it 'create subscription to author' do
      expect { create :question, user: user }.to change( user.subscriptions, :count ).by 1
    end
  end

  describe '.subscribe ( user )' do
    context 'not subscribed yet' do
      it 'creates subscription for user' do
        question
        expect { question.subscribe( user ) }.to change( Subscription, :count).by 1
      end
      it 'returnes subscription' do
        expect( question.subscribe( user )).to be_a Subscription
      end
    end
    context 'always subscribed' do
      before { subscription }
      it 'does not create subscription for user' do
        expect { subscription.question.subscribe(subscription.user) }
          .to_not change( Subscription, :count)
      end
      it 'returnes subscription' do
        expect( question.subscribe( user )).to be_a Subscription
      end
    end
  end
  describe '.unsubscribe ( user )' do
    context 'not subscribed yet' do
      it 'nothing to destroy' do
        question
        expect { question.unsubscribe( user ) }.to_not change( Subscription, :count)
      end
      it 'returnes subscription' do
        expect( question.unsubscribe( user )).to be nil
      end
    end
    context 'always subscribed' do
      before { subscription }
      it 'does not create subscription for user' do
        expect { subscription.question.unsubscribe( subscription.user ) }
          .to change( Subscription, :count).by -1
      end
      it 'returnes subscription' do
        expect( subscription.question.unsubscribe( subscription.user )).to be_a Subscription
      end
    end
  end
end
