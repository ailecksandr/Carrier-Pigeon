FactoryGirl.define do
  factory :message do
    body Faker::ChuckNorris.fact
    password '12345678'
    destroy_type 'reviewing'
    destroy_value 5
  end

  factory :expiring_message, parent: :message do
    destroy_type 'expiring'
  end

  factory :message_with_last_review, parent: :message do
    destroy_value 1
  end

  factory :empty_message, parent: :message do
    body ''
    password ''
  end
end
