require 'rails_helper'

include EmailSpec::Helpers
include EmailSpec::Matchers

RSpec.describe NewAnswersMailer, type: :mailer do
  describe '.alert (subscription)' do
    let(:subscription) { create :subscription }
    let(:mail) { NewAnswersMailer.alert subscription }

    it 'sends from the default email' do
      expect(mail).to be_delivered_from 'from@qna.test'
    end

    it 'sends to the correct user' do
      expect(mail).to be_delivered_to subscription.user.email
    end

    it 'has subject No questions Today' do
      expect(mail).to have_subject "New answers for #{subscription.question.title}"
    end

    it 'excludes new question title in body'  do
      expect(mail).to have_body_text(subscription.question.title)
    end
  end
end
