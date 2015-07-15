module Voting
  extend ActiveSupport::Concern


  included do
    before_action :set_votable, only: [:good, :shit, :revoke]
    before_action :prevent_author, only: [:good, :shit, :revoke]
    respond_to :json, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def good
    respond_with( @votable.vote_good_by( current_user )) do |format|
      format.json { render partial: 'shared/vote' }
    end
  end

  def shit
    respond_with( @votable.vote_shit_by( current_user )) do |format|
      format.json { render partial: 'shared/vote' }
    end
  end

  def revoke
    respond_with( @votable.vote_revoke_by( current_user )) do |format|
      format.json { render partial: 'shared/vote' }
    end
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find params[:id]
  end

  def prevent_author
    return if current_user.id != @votable.user_id
    render nothing: true, status: :forbidden
  end

end
