class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def me?
    record == user
  end
end
