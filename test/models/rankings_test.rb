# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class RankingsTest < ActiveSupport::TestCase
  include WebMocking

  setup do
    Rails.cache.clear

    @user1 = create(:user, id: 1, username: 'user1')
    @user2 = create(:user, id: 2, username: 'user2')
    @user3 = create(:user, id: 3, username: 'user3')

    3.times { create(:ad, :in_mad, user: @user1) }
    2.times { create(:ad, :in_mad, user: @user2) }
  end

  it '.top_overall ignores wanted ads from counts and results' do
    create(:ad, :want, user: @user3)
    @user2.ads.last.move!

    assert_equal [[1, 'user1', 3], [2, 'user2', 1]], User.top_overall.ranked
  end

  it '.top_overall gives all time top ad publishers' do
    create(:ad, user: @user3)

    assert_equal [[1, 'user1', 3], [2, 'user2', 2], [3, 'user3', 1]],
                 User.top_overall.ranked
  end

  it '.top_overall excludes banned users' do
    create(:ad, user: @user3)
    @user1.ban!

    assert_equal [[2, 'user2', 2], [3, 'user3', 1]], User.top_overall.ranked
  end

  it ".top_last_week gives last week's top publishers" do
    create(:ad, user: @user3, published_at: 8.days.ago)

    assert_equal [[1, 'user1', 3], [2, 'user2', 2]], User.top_last_week.ranked
  end

  it '.top_last_week excludes banned users' do
    create(:ad, user: @user3, published_at: 8.days.ago)
    @user1.ban!

    assert_equal [[2, 'user2', 2]], User.top_last_week.ranked
  end

  it '.top_locations returns cities with most ads' do
    mocking_yahoo_woeid_info(766_273) do
      assert_equal [[766_273, 'Madrid', 3 + 2]], Ad.top_locations.ranked
    end
  end

  it '.top_locations excludes ads by banned users' do
    mocking_yahoo_woeid_info(766_273) do
      @user1.ban!

      assert_equal [[766_273, 'Madrid', 2]], Ad.top_locations.ranked
    end
  end

  it '.top_overall city with all users ads in the same city' do
    assert_equal [[1, 'user1', 3], [2, 'user2', 2]],
                 User.top_city_overall(766_273).ranked
  end

  it '.top_overall city with users ads in different cities' do
    @user2.ads.last.update!(woeid_code: 753_692)

    assert_equal [[1, 'user1', 3], [2, 'user2', 1]],
                 User.top_city_overall(766_273).ranked

    assert_equal [[2, 'user2', 1]], User.top_city_overall(753_692).ranked
  end
end
