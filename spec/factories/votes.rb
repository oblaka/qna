FactoryGirl.define do
  factory :vote do
    rate 0
    association :votable, factory: :question
    association :voter, factory: :user
  end

end
