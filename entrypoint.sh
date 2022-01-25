#!/bin/bash
set -e
# 1L(スクリプトを/bin/bashで解釈し処理進行),2L(Bashの内部コマンド、シェルオプション値,位置パラメータ設定)
# Rails対応ファイルserver.pidを削除
rm -f /app/tmp/pids/server.pid
# create,seedはfargate初回のみ実行,以降は書換え配備
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
# コンテナプロセス実行(DockerfileのCMD,参考(https://qiita.com/RiSE_blackbird/items/e16c84cc18d4639d5d4f)）
exec "$@"