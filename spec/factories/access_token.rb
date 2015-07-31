FactoryGirl.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    application { create :oauth_app }
    resource_owner_id { create( :user ).id }
  end
end
