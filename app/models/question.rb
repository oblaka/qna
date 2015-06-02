class Question < ActiveRecord::Base
  has_many :answers
  validates :title, :body, presence: true
  validates :title, presence: true, length: { in: 6..69 }
  validates :body, presence: true, length: { in: 23..512 }
end
