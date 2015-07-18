class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :auths, dependent: :destroy
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: [:facebook, :twitter, :vkontakte]

  class << self

    def find_oauth auth_hash
      auth = Auth.where( provider: auth_hash.provider, uid: auth_hash.uid.to_s ).first
      return auth.user if auth
      return new unless auth_hash.info.key? :email
      user = find_by( email:auth_hash.info['email'] )
      user ||= User.confirmed_by auth_hash.info['email']
      user.add_auth_by( auth_hash )
      user
    end

    def confirmed_by email
      pass = Devise.friendly_token[0,23]
      create!( email: email, confirmed_at: Time.now,
               password: pass, password_confirmation: pass)
    end

    def unconfirmed_by email
      user = User.find_or_initialize_by( email: email)
      unless user.encrypted_password?
        pass = Devise.friendly_token[0,23]
        user.update(password: pass, password_confirmation: pass)
      end
      user
    end

  end

  def add_auth_by auth_hash
    auth = Auth.find_or_initialize_by( provider: auth_hash['provider'],
                                       uid: auth_hash['uid'].to_s )
    auth.new_record? ? auth.update(user: self) : false
  end

end
