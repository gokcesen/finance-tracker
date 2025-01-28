require 'alphavantage'

Alphavantage.configure do |config|
  config.api_key = Rails.application.credentials.alpha_vantage[:api_key]
end