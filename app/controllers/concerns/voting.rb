module Voting
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, :load_vote, only: [:good, :shit]
  end

  def good
    if signed_in? && current_user != @votable.user
      @vote.increase
      render 'shared/vote'
    else
      render nothing: true, status: :forbidden
    end
  end

  def shit
    if signed_in? && current_user != @votable.user
      @vote.decrease
      render 'shared/vote'
    else
      render nothing: true, status: :forbidden
    end
  end

  def load_vote
    @vote = @votable.vote_for current_user
  end

  def set_votable
    @votable = controller_name.classify.constantize.find params[:id]
  end

end
