module ApplicationHelper

  def good_btn_state votable
    unless signed_in? && current_user != votable.user && votable.vote_for(current_user).new_record?
      'disabled'
    end
  end

  def shit_btn_state votable
    unless signed_in? && current_user != votable.user && votable.vote_for(current_user).new_record?
      'disabled'
    end
  end

  def revoke_btn_state votable
    unless signed_in? && current_user != votable.user && votable.vote_for(current_user).persisted?
      'disabled'
    end
  end

end
