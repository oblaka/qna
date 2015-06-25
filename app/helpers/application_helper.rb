module ApplicationHelper

  def good_btn_state votable
    unless signed_in? && current_user != votable.user && votable.vote_for(current_user).rate < 1
      'disabled'
    end
  end

  def shit_btn_state votable
    unless signed_in? && current_user != votable.user && votable.vote_for(current_user).rate > -1
      'disabled'
    end
  end

end
