ENV["RAILS_ENV"] ||= "test"

require_relative '../config/environment'

require 'rails/test_help'

require 'minitest/pride'
require 'capybara/rails'

# Ensure sphinx directories exist for the test environment
ThinkingSphinx::Test.init

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  self.use_transactional_fixtures = true

  def setup
    I18n.default_locale = :es
    I18n.locale = :es
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActionDispatch::Routing::RouteSet
  def default_url_options(options={})
    {:locale => I18n.default_locale }
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  after do
    Capybara.reset_sessions!
  end
end
