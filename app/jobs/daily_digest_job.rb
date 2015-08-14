class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.find_each do |user|
      DigestMailer.daily(user).deliver_later
    end
  end
end
