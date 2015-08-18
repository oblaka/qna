require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:user) { create :user }

  it 'invoke digest mailer' do
    expect(DigestMailer)
      .to receive(:daily)
      .with(user)
      .and_return(DigestMailer.daily(user))
      .exactly(2).times
    DailyDigestJob.perform_now
  end
end
