class DigestMailer < ApplicationMailer
  def daily(user)
    @questions  = Question.daily
    mail to: user.email,
         subject: @questions.blank? ? 'No questions Today' : 'Last questions from QnA'
  end
end
