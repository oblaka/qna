class NewAnswerJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    question.subscriptions.find_each do |subs|
      NewAnswersMailer.alert(subs)
    end
  end
end
