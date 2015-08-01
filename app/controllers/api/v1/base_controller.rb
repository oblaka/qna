class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  after_action :verify_authorized

  respond_to :json

  protected

  def current_resource_owner
    @current_resourse_owner ||= User.find( doorkeeper_token.resource_owner_id ) if doorkeeper_token
  end

  alias_method :current_user, :current_resource_owner
end
