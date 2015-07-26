class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  delegate :good?, :shit?, :revoke?, to: :vote_policy

  def create?
    user.confirmed?
  end

  def new?
    create?
  end

  def update?
    owner?
  end

  def edit?
    update?
  end

  def destroy?
    owner?
  end

  def solution?
    user == record.question.user && record.best == false
  end

  private

  def vote_policy
    Pundit.policy!( @user, @record.vote_for( user ))
  end
end
