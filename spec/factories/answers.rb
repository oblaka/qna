FactoryGirl.define do
  factory :answer do
    user
    question
    best 'false'
    body 'You must going to sleep in this situation'
  end

  factory :invalid_answer, class: Answer do
    association :question
    best false
    body 'Fuck you!'
  end

  factory :answer1, class: Answer do
    user
    association :question
    best false
    body 'First awesome answer'
  end

  factory :answer2, class: Answer do
    user
    association :question
    best true
    body 'Second awesome answer'
  end
end
