class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :policy_check

  def index
    respond_with User.where.not(id: current_user.id)
  end

  def me
    respond_with current_user
  end

  private

  def policy_check
    authorize current_user
  end
end
