class VotePolicy < ApplicationPolicy
  def good?
    record.user != record.votable.user && record.new_record? && user.confirmed?
  end

  def shit?
    record.user != record.votable.user && record.new_record? && user.confirmed?
  end

  def revoke?
    owner? && record.persisted?
  end
end
