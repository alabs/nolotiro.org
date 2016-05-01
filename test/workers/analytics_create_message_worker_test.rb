class AnalyticsCreateMessageWorkerTest < ActiveSupport::TestCase

  require 'test_helper'
  require 'sidekiq/testing'

  def setup
    @user = FactoryGirl.create(:user)
    Sidekiq::Worker.clear_all
  end

  test "work added to the queue" do
    assert_equal 0, AnalyticsCreateMessageWorker.jobs.size
    AnalyticsCreateMessageWorker.perform_async @user.username
    assert_equal 1, AnalyticsCreateMessageWorker.jobs.size
  end
end