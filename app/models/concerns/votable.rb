module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  class_methods do
  end

  def vote_good_by user
    votes.create(user: user, rate: 1)
  end

  def vote_shit_by user
    votes.create(user: user, rate: -1)
  end

  def vote_revoke_by user
    vote = vote_for user
    vote.destroy if vote.persisted?
  end

  def vote_for user
    votes.find_or_initialize_by(user: user)
  end

end
