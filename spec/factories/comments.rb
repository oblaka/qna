FactoryGirl.define do
  factory :comment do
    body 'MyComment'
    association :commentable, factory: :question
    association :user, factory: :user
  end
end
