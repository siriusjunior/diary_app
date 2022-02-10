Sidekiq.configure_server do |config|
    config.redis = {
        url: 'redis://diaryapp-elasticache.8kyjko.0001.apne1.cache.amazonaws.com:6379' #本番環境はElastiCacheのEndpoint(Redisのサーバー名)
    }
end

Sidekiq.configure_client do |config|
    config.redis = {
        url: 'redis://diaryapp-elasticache.8kyjko.0001.apne1.cache.amazonaws.com:6379'
    }
end