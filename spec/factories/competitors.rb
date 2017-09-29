# frozen_string_literal: true

FactoryGirl.define do
  factory :competitor do
    group # association
    name Faker::Commerce.product_name

    trait :with_link do
      link Faker::Internet.url
    end

    trait :with_asin do
      product_asin Faker::Code.asin
    end
  end
end
