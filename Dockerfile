FROM ruby:2.7.5

# パッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                        libpq-dev \
                        nodejs \
    && rm -rf /var/lib/apt/lists/*

# コンテナのディレクトリ設定
ENV APP_ROOT /my_app
RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

ADD Gemfile ${APP_ROOT}/Gemfile
ADD Gemfile.lock ${APP_ROOT}/Gemfile.lock
RUN bundle install

ADD . ${APP_ROOT}