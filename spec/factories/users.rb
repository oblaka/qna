FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@pisem.net"
  end
  factory :user do
    email
    password '1234qwer'
    password_confirmation '1234qwer'
  end

end
