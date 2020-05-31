REDIS_IP = ENV["REDIS_IP"]
REDIS_PORT = ENV["REDIS_PORT"]
if defined?(REDIS_IP) && defined?(REDIS_PORT) && REDIS_IP && REDIS_PORT
  Sidekiq.configure_server do |config|
    config.redis = { url: "redis://#{REDIS_IP}:#{REDIS_PORT}/2" }
  end
  Sidekiq.configure_client do |config|
    config.redis = { url: "redis://#{REDIS_IP}:#{REDIS_PORT}/2" }
  end
end
