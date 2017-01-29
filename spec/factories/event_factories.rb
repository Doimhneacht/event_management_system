FactoryGirl.define do
  factory :event do
    time DateTime.tomorrow
    owner { FactoryGirl.create(:user).id }
    users { [FactoryGirl.create(:user)] }
  end
end
