class Question < ActiveRecord::Base
  has_many :answers
  validates :title, :body, presence: true
  validates :title, presence: true, length: { in: 4..69 }
  validates :body, presence: true, length: { in: 10..512 }
end
