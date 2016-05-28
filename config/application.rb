require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module YourGamePile
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    
    # Loads app config from /config/env_vars.yml
    unless Rails.env == 'production'
      require 'yaml'
      rails_root = Rails.root || File.dirname(__FILE__) + '/../..'
      config = YAML.load_file(rails_root.to_s + "/config/env_vars.yml")
      if config.key?(Rails.env) && config[Rails.env].is_a?(Hash)
        config[Rails.env].each do |key, value|
          ENV[key] = value.to_s
        end
      end
    end
  end
end
