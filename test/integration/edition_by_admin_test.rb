# frozen_string_literal: true
require 'test_helper'
require 'support/web_mocking'

class EditionsByAdmin < ActionDispatch::IntegrationTest
  include WebMocking
  include Warden::Test::Helpers

  before do
    @ad = create(:ad, woeid_code: 766_273, type: 1)
    login_as create(:admin, woeid: 766_272)
  end

  after { logout }

  it 'changes only the edited attribute' do
    mocking_yahoo_woeid_info(@ad.woeid_code) do
      visit ads_edit_path(@ad)
      select 'busco...', from: 'ad_type'
      click_button 'Enviar'

      assert_equal 766_273, @ad.reload.woeid_code
      assert_equal 2, @ad.reload.type
    end
  end
end
