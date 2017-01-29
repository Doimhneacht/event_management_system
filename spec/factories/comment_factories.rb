FactoryGirl.define do
  factory :comment do
    text 'Is maith liom beoir.'
    user
    event
  end
end
