require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do

  let(:subscription) { create :subscription }
  let(:question) { create :question }

  it 'invoke new answers mailer' do
    subs = question.subscriptions.first
    expect(NewAnswersMailer)
    .to receive(:alert)
    .with(subs)
    .and_return(NewAnswersMailer.alert(subs))
    NewAnswerJob.perform_now question
  end
end
