FactoryGirl.define do
  factory :question do
    user
    title 'My Question'
    body 'My Detailed shit'
  end

  factory :invalid_question, class: Question do
    title nil
    body nil
  end
end
