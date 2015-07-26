module Voting
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:good, :shit, :revoke]
    respond_to :json
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
    authorize @votable
  end
end
