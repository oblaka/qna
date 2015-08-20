module QuestionsHelper
  def subscription_link(question)
    if policy(question).subscribe?
      link_to 'subscribe', subscribe_question_path(question),
              method: :post, remote: true, class: 'btn btn-warning btn-xs'
    else
      link_to 'unsubscribe', unsubscribe_question_path(question),
              method: :post, remote: true, class: 'btn btn-danger btn-xs'
    end
  end

  def question_cache_key(question)
    own = "#{policy(question).owner?}"
    "question-#{question.id}-#{own}-#{question.updated_at.to_i}"
  end
end
