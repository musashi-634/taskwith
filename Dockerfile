# 公式イメージ：https://hub.docker.com/_/ruby
FROM ruby:3.2.2
ENV APP_ROOT /myapp
RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}
COPY Gemfile ${APP_ROOT}/Gemfile
COPY Gemfile.lock ${APP_ROOT}/Gemfile.lock

# コンテナ起動時に実行させるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
