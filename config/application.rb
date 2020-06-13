require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Qna
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    #config.autoload_paths += [config.root.join('app')]

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
    end

    config.active_job.queue_adapter = :sidekiq
    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.worker_pool_size = 4

    # config.session_store :cache_store, key: 'session'

    config.session_store :redis_session_store, {
        key: 'session',
        redis: {
            expire_after: 3.days,  # cookie expiration
            ttl: 3.days,           # Redis expiration, defaults to 'expire_after'
            key_prefix: 'session:',
            url: "redis://#{ENV["REDIS_IP"]}:#{ENV["REDIS_PORT"]}/0"
        }
    }

  end
end
