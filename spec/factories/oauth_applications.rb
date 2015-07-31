FactoryGirl.define do
  factory :oauth_app, class: Doorkeeper::Application do
    name 'Another App'
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
    uid '12345678'
    secret '87654321'
  end
end
