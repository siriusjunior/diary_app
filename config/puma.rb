# threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
# threads threads_count, threads_count

# # port        ENV.fetch("PORT") { 3000 }
# bind "unix://#{Rails.root}/tmp/sockets/puma.sock"

# # environment ENV.fetch("RAILS_ENV") { "development" }
# environment ENV.fetch("RAILS_ENV") { "production" }
# pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
# plugin :tmp_restart

# stdout_redirect "#{Rails.root}/log/puma.stdout.log", "#{Rails.root}/log/puma.stderr.log", true

# 開発環境への切り替え
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
plugin :tmp_restart
app_root = File.expand_path("../..", __FILE__)

# UNIXソケットを使う場合,TCPより若干パフォーマンスが上がる(参照https://nekorails.hatenablog.com/entry/2018/10/12/101011)
bind "unix://#{app_root}/tmp/sockets/puma.sock"
# 標準出力/標準エラーを出力するファイル(puma.rb構成参考https://qiita.com/eighty8/items/0288ab9c127ddb683315)
stdout_redirect "#{app_root}/log/puma.stdout.log", "#{app_root}/log/puma.stderr.log", true