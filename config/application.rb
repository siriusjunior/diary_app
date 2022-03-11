require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DiaryApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    #以下のtime_zoneで、plan.rbのTime.currentがJSTになるが、messageモデルのcreated_atがUTCで不整合が起きるため指定しない
    #config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
    # デフォルトのlanguageを:jaに設定
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.assets  false # CSS, JSが自動生成されない
      g.test_framework  false # Minitestが自動生成されない
      g.skip_routes  true # ルーティングが自動生成されない
      g.test_framework :rspec,
        view_specs: false,
        helper_specs: false,
        controller_specs: false,
        routing_specs: false,
        request_specs: false
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
