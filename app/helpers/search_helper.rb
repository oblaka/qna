module SearchHelper
  def snippet_body(obj)
    case
    when obj.is_a?(User)
      "with email #{obj.email}"
    when obj.is_a?(Question) || obj.is_a?(Answer) || obj.is_a?(Comment)
      "found in #{obj.class.name}: \t ".concat obj.body.split[0...5].join(' ')
    end
  end

  def snippet_goal(obj)
    case
    when obj.is_a?(User)
      obj
    when obj.is_a?(Question)
      obj
    when obj.is_a?(Answer)
      obj.question
    when obj.is_a?(Comment)
      if obj.commentable.is_a? Answer
        obj.commentable.question
      elsif obj.commentable.is_a? Question
        obj.commentable
      end
    end
  end
end
