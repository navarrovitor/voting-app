require_relative "boot"
require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module VotingApp
  class Application < Rails::Application
    config.load_defaults 7.2
    config.api_only = true
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: [:get, :post, :put, :patch, :delete, :options]
      end
    end
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV.fetch("SMTP_HOST", "smtp.gmail.com"),
      port: ENV.fetch("SMTP_PORT", 587).to_i,
      domain: ENV.fetch("APP_HOST", "localhost"),
      user_name: ENV["SMTP_USER"],
      password: ENV["SMTP_PASS"],
      authentication: :plain,
      enable_starttls_auto: true
    }
    config.action_mailer.default_url_options = { host: ENV.fetch("APP_HOST", "localhost:3000"), protocol: ENV.fetch("APP_PROTOCOL", "http") }
  end
end
