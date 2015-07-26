class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :votable, :user, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :rate, numericality: { only_integer: true }

  delegate :rating, to: :votable

  after_create :cast
  before_destroy :revoke

  private

  def cast
    votable.increment! :rating, rate
  end

  def revoke
    votable.decrement! :rating, rate
  end
end
