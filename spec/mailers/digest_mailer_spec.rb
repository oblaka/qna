require_relative 'mailer_helper'

include EmailSpec::Helpers
include EmailSpec::Matchers

RSpec.describe DigestMailer, type: :mailer do
  describe '.daily (user)' do
    let(:user) { create :user }
    let(:new_question) { create :question, title: 'New question', created_at: Time.now }
    let(:old_question) { create :question, title: 'Old question', created_at: 3.days.ago }
    let(:mail) { DigestMailer.daily user }

    it 'sends from the default email' do
      expect(mail).to be_delivered_from 'mailer@bobracorp.ru'
    end

    it 'sends to the correct user' do
      expect(mail).to be_delivered_to user.email
    end

    context 'if no new questions' do
      it 'has subject No questions Today' do
        expect(mail).to have_subject 'No questions Today'
      end

      it 'excludes new question title in body'  do
        expect(mail).to_not have_body_text(build(:question).title)
      end

      it 'excludes old question title in body'  do
        expect(mail).to_not have_body_text(old_question.title)
      end
    end

    context 'if new questions found' do
      before do
        new_question
      end
      it 'has subject Last questions from QnA' do
        expect(mail).to have_subject 'Last questions from QnA'
      end

      it 'includes new question title in body'  do
        expect(mail).to have_body_text(new_question.title)
      end

      it 'excludes old question title in body'  do
        expect(mail).to_not have_body_text(old_question.title)
      end
    end
  end
end
