class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :set_auth_hash, only: [:facebook, :twitter, :vkontakte]
  before_action :authenticate_user!, only: [:profile]
  before_action :try_add_auth, only: [:profile]

  def facebook
    getting_hash
  end
  def twitter
    getting_hash
  end
  def vkontakte
    getting_hash
  end

  def confirm_email
    @email = params.require(:user).permit(:email)['email']
    @user = User.unconfirmed_by(@email)
    if @user.confirmed?
      redirect_to new_user_session_path
      set_flash_message(:notice, :unauthenticated)
    else
      redirect_to root_path
      set_flash_message(:notice, :unconfirmed)
    end
  end

  def profile
    @user = current_user
  end

  private

  def getting_hash
    @user = User.find_oauth @auth_hash
    if signed_in?
      add_auth_by_auth_hash
    else
      sign_in_by_auth_hash
    end
  end

  def sign_in_by_auth_hash
    if @user.persisted?
      sign_in @user
      redirect_to profile_path, event: :authentication
      set_flash_message(:notice, :success, kind: @auth_hash.provider) if is_navigational_format?
    else
      session[:oauth_hash] = @auth_hash.slice(:provider, :uid)
      render 'email_form'
      set_flash_message(:notice, :no_email, kind: @auth_hash.provider) if is_navigational_format?
    end
  end

  def add_auth_by_auth_hash
    if current_user.add_auth_by @auth_hash
      redirect_to profile_path
      set_flash_message(:notice, :succesfully_added, kind: @auth_hash.provider) if is_navigational_format?
    else
      redirect_to root_path
      set_flash_message(:notice, :already_exists, kind: @auth_hash.provider) if is_navigational_format?
    end
  end

  def try_add_auth
    if session.key? :oauth_hash
      current_user.add_auth_by session.delete(:oauth_hash)
      set_flash_message(:notice, :succesfully_added, kind: @auth_hash.provider) if is_navigational_format?
    end
  end

  def set_auth_hash
    @auth_hash = request.env['omniauth.auth'] || session[:oauth_hash]
  end
end
