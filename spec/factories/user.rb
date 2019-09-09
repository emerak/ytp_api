# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'john@test.com' }
    password { 'testpass' }
  end

  trait :admin do
    role { 'admin' }
  end

  trait :holder do
    role { 'holder' }
  end
end
