# frozen_string_literal: true

FactoryGirl.define do
  factory :group do
    name Faker::Company.name

    trait :with_competitors do
      transient do
        competitors_count 3
      end

      after(:create) do |group, evaluator|
        create_list(:competitor_valid, evaluator.competitors_count,
                    group: group)
      end
    end
  end
end
