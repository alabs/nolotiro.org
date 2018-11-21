# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "foo#{n}@example.com"
  end

  sequence :username do |n|
    "username#{n}"
  end

  factory :user do
    username
    email
    password "123456789"
    role 0
    madrilenian
    confirmed_at Time.zone.now
    terms true
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    username
    email "admin@example.com"
    password "12435968770"
    role 1
    confirmed_at Time.zone.now
    terms true
  end

  factory :non_confirmed_user, class: User do
    username
    email
    password "123456789"
    role 0
    madrilenian
    terms true
  end

  trait(:madrilenian) { woeid 766_273 }
  trait(:stateless) { woeid nil }

  trait(:spammer) do
    banned_at { 3.days.ago }
  end

  trait(:old_spammer) do
    banned_at { 4.months.ago }
  end

  trait(:recent_spammer) do
    banned_at { 2.months.ago }
  end
end
