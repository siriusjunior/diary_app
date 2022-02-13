Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  # config.assets.js_compressor = :uglifier
  
  # EC2上でES6 syntaxを有効にするために追記(https://qiita.com/terufumi1122/items/27bf288414569e13e050)
  config.assets.js_compressor = Uglifier.new(harmony: true)
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  config.action_cable.allowed_request_origins = [ 'https://www.diaryapp.net/' ]
  ActionCable.server.config.disable_request_forgery_protection = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "diary_app_#{Rails.env}"

  config.action_mailer.perform_caching = false

  # SorceryによるメールサーバーにGmailを指定
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'https://www.diaryapp.net/' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.gmail.com',
    enable_starttls_auto: true,
    port: 587,
    user_name: ENV['GMAIL_USER'],
    password: ENV['GMAIL_PASSWORD'],
    authentication: :plain,
  }
  
  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # 静的なファイルをRailsから返す
  config.public_file_server.enabled = true

  # 環境ごとにsession_store.rbから分離
  config.session_store :redis_store, {
    servers: [
        {
            host: "diaryapp-elasticache.8kyjko.0001.apne1.cache.amazonaws.com", #本番環境はElastiCacheのEndpoint(Redisのサーバー名)
            port: 6379, #Redisのサーバーのポート
            db: 0, #データーベースの番号(0~15)任意
            namespace: "session" #名前空間,"session:セッションID"の形式
        },
    ],
    expire_after: 1.day #保存期間
  } 
  
  # 環境ごとにsidekiq.rbから分離
  Sidekiq.configure_server do |config|
    config.redis = {
      url: 'redis://diaryapp-elasticache.8kyjko.0001.apne1.cache.amazonaws.com:6379' #本番環境はElastiCacheのEndpoint(Redisのサーバー名)
    }
  end
  Sidekiq.configure_client do |config|
    config.redis = {
      url: 'redis://diaryapp-elasticache.8kyjko.0001.apne1.cache.amazonaws.com:6379' #本番環境はElastiCacheのEndpoint(Redisのサーバー名)
    }
  end
end
