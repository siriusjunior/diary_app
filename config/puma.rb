threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# port        ENV.fetch("PORT") { 3000 }
bind "unix://#{Rails.root}/tmp/sockets/puma.sock"

# environment ENV.fetch("RAILS_ENV") { "development" }
environment ENV.fetch("RAILS_ENV") { "production" }
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
plugin :tmp_restart

stdout_redirect "#{Rails.root}/log/puma.stdout.log", "#{Rails.root}/log/puma.stderr.log", true