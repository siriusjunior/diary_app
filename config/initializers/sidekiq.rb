Sidekiq.configure_server do |config|
    config.redis = {
        url: 'redis://localhost:6379'
        #redisコンテナではなくビルド用に上記に書換え
        # url: 'redis://redis:6379'
    }
end

Sidekiq.configure_client do |config|
    config.redis = {
        url: 'redis://localhost:6379'
        #redisコンテナではなくビルド用に上記に書換え
        # url: 'redis://redis:6379'
    }
end