class Question < ActiveRecord::Base
  include Commentable
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_one :solution, -> { where best: true }, class_name: 'Answer'
  has_many :attachments, as: :attachable
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, :user, presence: true
  validates :title, presence: true, length: { in: 4..69 }
  validates :body, presence: true, length: { in: 10..512 }
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :daily, -> { where('created_at > ?', 1.day.ago) }

  after_create :subscribe_author

  def subscribe(user)
    subscriptions.find_or_create_by(user: user)
  end

  def unsubscribe(user)
    sub = subscriptions.find_by(user: user)
    sub.destroy if sub
  end

  private

  def subscribe_author
    subscribe user
  end
end
