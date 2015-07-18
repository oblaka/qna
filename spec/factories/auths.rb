FactoryGirl.define do
  factory :fb_auth, class: Auth do
    association :user, factory: :user
    provider "facebook"
    uid "MyUidString"
  end

  factory :tw_auth, class: Auth do
    association :user, factory: :user
    provider "twitter"
    uid "MyUidString"
  end

  factory :vk_auth, class: Auth do
    association :user, factory: :user
    provider "vkontakte"
    uid "MyUidString"
  end

end
