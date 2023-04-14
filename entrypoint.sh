#!/bin/bash
# set -e は「エラーが発生するとスクリプトを終了する」オプション
set -e

gem update --system

bundle config set --local path 'vendor/bundle'

bundle install -j3

# コンテナのメインプロセスを実行する（Dockerfile 内の CMD に設定されているもの）
exec "$@"
