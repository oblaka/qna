class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { in: 7..256 }
  validates :commentable, presence: true
  validates :user, presence: true

end
