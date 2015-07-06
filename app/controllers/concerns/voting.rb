module Voting
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:good, :shit, :revoke]
  end

  def good
    if current_user.id != @votable.user_id
      @votable.vote_good_by(current_user)
      render 'shared/vote'
    else
      render nothing: true, status: :forbidden
    end
  end

  def shit
    if current_user.id != @votable.user_id
      @votable.vote_shit_by(current_user)
      render 'shared/vote'
    else
      render nothing: true, status: :forbidden
    end
  end

  def revoke
    @votable.vote_revoke_by(current_user)
    render 'shared/vote'
  end

  def set_votable
    @votable = controller_name.classify.constantize.find params[:id]
  end

end
