require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tripler
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # Load local ENV vars
    local_env = File.join(Rails.root, "config", "local_variables.rb")
    load(local_env) if File.exists?(local_env)

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.autoload_paths += %W(#{config.root}/lib)

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: "smtpout.secureserver.net",
      domain: "www.triple-r-farms.com",
      port: 80,
      user_name: ENV["EMAIL_USERNAME"],
      password: ENV["EMAIL_PASSWORD"],
      authentication: :plain
    }
  end
end
