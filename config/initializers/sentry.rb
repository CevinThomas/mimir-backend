# frozen_string_literal: true

Sentry.init do |config|
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.dsn = ENV['SENTRY_DSN']
  config.enable_tracing = true
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
  # Set profiles_sample_rate to profile 100%
  # of sampled transactions.
  # We recommend adjusting this value in production.
  config.profiles_sample_rate = 1.0
end
