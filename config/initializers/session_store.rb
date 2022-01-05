Rails.application.config.session_store :redis_store, {
    servers: [
        {
            host: "localhost",  #Redisのサーバー名
            # host: "redis",  #Redisのサーバー名 redisコンテナではなくビルド用に上記に書換え
            port: 6379, #Redisのサーバーのポート
            db: 0, #データーベースの番号(0~15)任意
            namespace: "session" #名前空間,"session:セッションID"の形式
        },
    ],
    expire_after: 1.day #保存期間
}