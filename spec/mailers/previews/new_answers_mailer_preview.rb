# Preview all emails at http://localhost:3000/rails/mailers/new_answers_mailer
class NewAnswersMailerPreview < ActionMailer::Preview
  def alert
    NewAnswersMailer.alert Subscription.last
  end
end
