module CommentsHelper
  def comment_link(commentable)
    link_to 'comment', '#',
            data: { com_id: commentable.id, com_type: commentable.class.to_s.downcase },
            remote: true, class: 'btn btn-link comment-link',
            id: "new_comment_#{commentable.class.name.underscore}_#{commentable.id}"
  end

  def div_comments_id(commentable)
    "comments_#{commentable.class.name.underscore}_#{commentable.id}"
  end

  # def comment_cache_key_for(commentable)
  #   name = commentable.class.name
  #   count = commentable.comments.count
  #   max_updated_at = commentable.comments.maximum(:updated_at).try(:utc).try(:to_s)
  #   "#{name}-comments-#{count}-#{max_updated_at}"
  # end
end
