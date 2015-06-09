FactoryGirl.define do

  factory :answer do
    user
    question
    body "You must going to sleep in this situation"
  end

  factory :invalid_answer, class: Answer do
    association :question
    body "Fuck you!"
  end

end
