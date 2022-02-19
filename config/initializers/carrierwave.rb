CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage    = :aws
    config.aws_bucket = 's3.diaryapp.net'
    config.aws_acl    = 'private'

    # Optionally define an asset host for configurations that are fronted by a
    # content host, such as CloudFront.
    config.asset_host = 'https://d3kz0w7mdk1yih.cloudfront.net'

    # The maximum period for authenticated_urls is only 7 days.
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    # Set custom options such as cache control to leverage browser caching.
    # You can use either a static Hash or a Proc.
    config.aws_attributes = -> { {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    } }

    config.aws_credentials = {
      access_key_id:     ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY'],
      region:            'ap-northeast-1'
    }
  else
    config.storage :file # 開発環境local
    config.enable_processing = false if Rails.env.test? #テスト環境スキップ
  end
end