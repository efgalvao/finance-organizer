require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FinanceOrganizer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'UTC'
    config.i18n.default_locale = :pt
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # config.eager_load_paths << Rails.root.join("extras")
    Money.locale_backend = :currency
    Money.default_currency = Money::Currency.new('BRL')
    Money.rounding_mode = BigDecimal::ROUND_HALF_UP
  end
end
