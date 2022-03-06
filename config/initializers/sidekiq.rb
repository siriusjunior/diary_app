Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV["SIDEKIQ_URL"] #本番環境はElastiCacheのEndpoint(Redisサーバー名)
  }
end
Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV["SIDEKIQ_URL"] #本番環境はElastiCacheのEndpoint(Redisサーバー名)
  }
end