FactoryGirl.define do
  factory :user do
    sequence(:name)       { |n| "Person#{n}" }
    sequence(:email)      { |n| "person#{n}@example.com" }
    password                "foobar"
    password_confirmation   "foobar"

    # Can create admin with this using FactoryGirl.create(:admin)
    factory :admin do
      admin true
    end
  end
  # Passing :user tells FactoryGirl that the following def is for the User model object
end
