Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true
  # config.assets.compile = true

  # 挙動調整のため追記するかも、app/assets/javascripts/配下に置かれているJSファイル群はAssets Pipeline の対象外になってしまうので以下の行を追加
  # config.assets.precompile += ['*.js']

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # コンテナの再起動を行わずにデバッグが可能
  config.file_watcher = ActiveSupport::FileUpdateChecker
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.action_mailer.default_url_options = Settings.default_url_options.to_h
  config.action_mailer.delivery_method = :letter_opener
  
  # whitelistの検証無効化
  config.web_console.whiny_requests = false
  
  # Cannot render console fromに対応
  config.web_console.whitelisted_ips = '172.22.0.1'

  # 環境ごとにsession_store.rbから分離
  config.session_store :redis_store, {
    servers: [
        {
            host: "localhost",  #Redisのサーバー名
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
      url: 'redis://localhost:6379'
    }
  end
  Sidekiq.configure_client do |config|
    config.redis = {
      url: 'redis://localhost:6379'
    }
  end

end
