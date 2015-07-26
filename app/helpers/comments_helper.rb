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
end
