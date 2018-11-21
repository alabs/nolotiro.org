# frozen_string_literal: true

def create_ad(user)
  timestamp = rand((Time.zone.now - 1.week)..Time.zone.now)
  ad = Ad.create(
    user: user,
    title: Faker::Hipster.sentence(3).truncate(60),
    created_at: timestamp,
    published_at: timestamp,
    body: Faker::Hipster.paragraphs.join("\n"),
    type: :give,
    status: :available,
    woeid_code: 766_273,
    image: Faker::Placeholdit.image
  )
  ad
end

User.create!(
  username: "admin",
  email: "admin@example.org",
  role: 1,
  password: "12345678",
  password_confirmation: "12345678",
  confirmed_at: Time.zone.now,
  woeid: 766_273,
  terms: true
)

10.times do |n|
  User.create!(
    username: Faker::Name.name,
    email: "user#{n}@example.org",
    role: 0,
    password: "12345678",
    password_confirmation: "12345678",
    confirmed_at: Time.zone.now,
    woeid: 766_273,
    terms: true
  )
end

30.times do
  user = User.offset(rand(User.count)).first
  create_ad(user)
end
