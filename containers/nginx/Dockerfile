FROM nginx:1.15.8

# インクルード用のディレクトリ内を削除
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナ指定ファイルに追加
ADD nginx.conf /etc/nginx/conf.d/webapp.conf

# ビルド完了後にNginxを起動
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf

# 参考https://qiita.com/eighty8/items/0288ab9c127ddb683315