# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts '==================== creating user ===================='
# 「組織の構図」
#
# 山田課長 @製品開発部　機械設計グループ
#   |-- 佐藤リーダー（新規開発業務）
#   |     |-- Alice
#   |     |-- Bob
#   |-- 鈴木リーダー（不具合対応業務）
#         |-- 星野
#         |-- 斎藤

USER_PASSWORD = 'test123'

user_yamada = User.create!(
  name: '山田　太郎',
  email: 'taro.yamada@example.com',
  password: USER_PASSWORD,
  password_confirmation: USER_PASSWORD
)
user_sato = User.create!(
  name: '佐藤　守',
  email: 'mamoru.sato@example.com',
  password: USER_PASSWORD,
  password_confirmation: USER_PASSWORD
)
user_alice = User.create!(
  name: 'Alice.W',
  email: 'alice.williams@example.com',
  password: USER_PASSWORD,
  password_confirmation: USER_PASSWORD
)
user_bob = User.create!(
  name: 'Bob.J',
  email: 'bob.johnson@example.com',
  password: USER_PASSWORD,
  password_confirmation: USER_PASSWORD
)
user_suzuki = User.create!(
  name: '鈴木　咲',
  email: 'saki.suzuki@example.com',
  password: USER_PASSWORD,
  password_confirmation: USER_PASSWORD
)
user_hoshino = User.create!(
  name: '星野　結衣',
  email: 'yui.hoshino@example.com',
  password: USER_PASSWORD,
  password_confirmation: USER_PASSWORD
)
user_saito = User.create!(
  name: '斎藤　修',
  email: 'osamu.saito@example.com',
  password: USER_PASSWORD,
  password_confirmation: USER_PASSWORD
)

puts '==================== creating project ===================='
# 新規開発業務
Project.create!(
  name: '機構Aの騒音低減',
  description: '【保留】製品Aの機構Aの動作音の低減。改善要望がほとんどないため、保留。次世代機で対応する方針。',
  is_done: false,
  is_archived: true,
  users: [user_yamada, user_sato, user_bob]
)
Project.create!(
  name: '製品Bの開発',
  description: '大規模病院向けの製品Bの開発。',
  is_done: false,
  is_archived: false,
  users: [user_yamada, user_sato, user_bob, user_alice]
)
Project.create!(
  name: '安全法令Aの対応',
  description: '2024年4月に施行される海外の安全法令Aの対応。設けられた安全基準に対し、2024年3月末までに全件対応必須。対象装置は、法令適用後に出荷されるもの全て。',
  is_done: false,
  is_archived: false,
  users: [user_yamada, user_sato, user_alice]
)

# 不具合対応業務
Project.create!(
  name: '機構Aのコード断線対応',
  description: 'A医療センターで発生した、製品Aの機構Aのコード断線の対応。',
  is_done: true,
  is_archived: true,
  users: [user_yamada, user_suzuki, user_hoshino]
)
Project.create!(
  name: '機構Bのアーム破損対応',
  description: 'B市民病院で発生した、製品Aの機構Bのアーム破損の対応。',
  is_done: false,
  is_archived: false,
  users: [user_yamada, user_suzuki, user_hoshino]
)
Project.create!(
  name: '機構Cのセンサ誤検知対応',
  description: 'C大学付属病院で発生した、製品Aの機構Cのセンサ誤検知の対応。',
  is_done: true,
  is_archived: false,
  users: [user_yamada, user_suzuki, user_saito]
)
