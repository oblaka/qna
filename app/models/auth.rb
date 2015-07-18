class Auth < ActiveRecord::Base
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:provider, :uid] }
end
