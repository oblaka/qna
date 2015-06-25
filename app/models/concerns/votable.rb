module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  class_methods do
  end

  def vote_for user
    votes.find_or_initialize_by(voter: user)
  end

  def rating
    votes.find_or_initialize_by(voter: self).rate
  end

end
