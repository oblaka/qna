# Preview all emails at http://localhost:3000/rails/mailers/digest_mailer
class DigestMailerPreview < ActionMailer::Preview
  def daily
    DigestMailer.daily User.first
  end
end
