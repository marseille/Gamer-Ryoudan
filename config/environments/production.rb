GamerRyoudan::Application.configure do
  config.active_support.deprecation = :log
  config.cache_classes = false
  config.eager_load = true
  
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Enable threaded mode
  # config.threadsafe!

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Full error reports are disabled and caching is turned on
  config.action_controller.consider_all_requests_local = false
  config.action_mailer.perform_deliveries = true
  config.action_controller.perform_caching             = true
  config.log_level = :debug
  config.action_mailer.raise_delivery_errors = true

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host                  = "http://assets.example.com"

  #changed password to ENV["EMAIL_PASS"], hiding password from
  #viewers
  ActionMailer::Base.smtp_settings = {
      :address              => 'smtp.gmail.com',
      :port                 => 587,
      :domain               => 'gmail.com',
      :user_name            => 'do.not.reply.gamer.ryoudan@gmail.com',
      :password             => ENV["EMAIL_PASS"],
      :authentication       => 'login',
      :enable_starttls_auto => true
  }
