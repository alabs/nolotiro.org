unless Rails.application.secrets["localeapp_apikey"].empty?

  require 'localeapp/rails'

  Localeapp.configure do |config|
    config.api_key = Rails.application.secrets["localeapp_apikey"]
    config.sending_environments = []
    config.reloading_environments = []
    config.cache_missing_translations = true
  end
end
