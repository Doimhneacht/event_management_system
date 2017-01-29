FactoryGirl.define do
  factory :event do
    time DateTime.tomorrow
    # association :owner, factory: :user
    owner { FactoryGirl.create(:user).id }
    users { [FactoryGirl.create(:user)] }
  end
end
