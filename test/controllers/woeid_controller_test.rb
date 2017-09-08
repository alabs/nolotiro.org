# frozen_string_literal: true

require 'test_helper'
require 'support/web_mocking'

class WoeidControllerTest < ActionController::TestCase
  include WebMocking
  include Devise::Test::ControllerHelpers

  setup do
    @ad = create(:ad)
  end

  it 'gets listall and give (available, delivered, booked)' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, params: { type: 'give', status: 'available' }
      assert_response :success
      get :show, params: { type: 'give', status: 'booked' }
      assert_response :success
      get :show, params: { type: 'give', status: 'delivered' }
      assert_response :success
      assert_generates '/ad/listall/ad_type/give',
                       controller: 'woeid', action: 'show', type: 'give'
    end
  end

  it 'gets WOEID and give (available, delivered, booked)' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, params: { type: 'give', status: 'available', id: @ad.woeid_code }
      assert_response :success
      get :show, params: { type: 'give', status: 'booked', id: @ad.woeid_code }
      assert_response :success
      get :show, params: { type: 'give', status: 'delivered', id: @ad.woeid_code }
      assert_response :success
    end
  end

  it 'gets WOEID and want' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, params: { type: 'want', id: @ad.woeid_code }
      assert_response :success
    end
  end

  it 'accepts a query search parameter' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, params: { type: 'give', q: 'ordenador', id: @ad.woeid_code }
      assert_response :success
    end
  end

  it 'accepts a query search parameter when no results' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, params: { type: 'give', q: 'notfound', id: @ad.woeid_code }
      assert_response :success
    end
  end

  it 'accepts a query search parameter when WOEID code param not specified' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      get :show, params: { type: 'give', q: 'ordenador' }
      assert_response :success
    end
  end
end
