Sidekiq.configure_server do |config|
  config.redis = { url:  ENV['LNG_REDIS_SIDEKIQ_URL'] }
  config.log_formatter = Sidekiq::Logger::Formatters::JSON.new
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['LNG_REDIS_SIDEKIQ_URL'] }
end
