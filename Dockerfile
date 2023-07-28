# 公式イメージ：https://hub.docker.com/_/ruby
FROM ruby:3.2.2
RUN mkdir /taskwith
WORKDIR /taskwith
COPY Gemfile /taskwith/Gemfile
COPY Gemfile.lock /taskwith/Gemfile.lock

# コンテナ起動時に実行させるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
