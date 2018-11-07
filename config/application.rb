require_relative 'boot'

require 'rails/all'
require 'sprockets/es6'

require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Stoperica
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.react.camelize_props = true
    config.i18n.default_locale = :hr
    config.action_dispatch.default_headers = {
     'X-Frame-Options' => 'ALLOWALL'
    }
    config.action_mailer.asset_host = 'http://stoperica.herokuapp.com'
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.generators do |g|
      g.template_engine :haml
    end
  end
end
