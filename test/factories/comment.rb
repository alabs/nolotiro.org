# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body 'Qué cosa buena que regalas!'
    ad
    ip '28.3.2.4'
    user
  end
end
