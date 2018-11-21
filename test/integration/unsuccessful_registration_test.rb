# frozen_string_literal: true

require "test_helper"

class UnsuccessfulRegistrationTest < ActionDispatch::IntegrationTest
  before do
    visit root_path
    click_link "nuevo usuario"
    click_button "Regístrate"
  end

  it "shows errors" do
    assert_text "Ocurrieron 4 errores"
  end
end
