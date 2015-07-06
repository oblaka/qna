class Question < ActiveRecord::Base

  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :solution, -> { where best: true }, class_name: "Answer"
  has_many :attachments, as: :attachable
  validates :title, :body, :user, presence: true
  validates :title, presence: true, length: { in: 4..69 }
  validates :body, presence: true, length: { in: 10..512 }
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
