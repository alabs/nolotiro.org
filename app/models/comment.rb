# frozen_string_literal: true

class Comment < ApplicationRecord
  include Censurable
  censors :body

  include Hidable
  include Statable

  counter_stats_for :created_at

  belongs_to :user, foreign_key: :user_owner, inverse_of: :comments
  belongs_to :ad, foreign_key: :ads_id, inverse_of: :comments

  validates :ads_id, presence: true
  validates :user_owner, presence: true
  validates :ip, presence: true

  validates :body, presence: true, length: { maximum: 1000 }

  scope :oldest_first, -> { order(created_at: :asc) }
end
