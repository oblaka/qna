class NewAnswersMailer < ApplicationMailer

  def alert(subscription)
    @question = subscription.question
    mail to: subscription.user.email,
         subject: 'New answers for '.concat( @question.title )
  end

end
