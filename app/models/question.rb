class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :solution, -> { where best: true }, class_name: "Answer"
  validates :title, :body, :user, presence: true
  validates :title, presence: true, length: { in: 4..69 }
  validates :body, presence: true, length: { in: 10..512 }
end
