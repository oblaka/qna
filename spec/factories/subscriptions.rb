FactoryGirl.define do

  factory :subscription do
    association :user, factory: :user
    association :question, factory: :question
  end

end
