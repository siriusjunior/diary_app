FROM ruby:2.6.4

# パッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                        libpq-dev \
                        nodejs \
    && rm -rf /var/lib/apt/lists/*

# コンテナのディレクトリ設定
ENV APP_ROOT /app
RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

ADD Gemfile ${APP_ROOT}/Gemfile
ADD Gemfile.lock ${APP_ROOT}/Gemfile.lock
RUN bundle install

ADD . ${APP_ROOT}
# yarnパッケージのインストール
# RUN yarn add bootstrap bootstrap-material-design jquery popper.js