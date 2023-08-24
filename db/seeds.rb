# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts '==================== creating organization ===================='

jmd_organization = Organization.create!(
  name: '株式会社JMD'
)
kanagawa_steel_organization = Organization.create!(
  name: '神奈川製鉄株式会社'
)

puts '==================== creating user ===================='

# 「JMD株式会社の組織構図」
#
# 山田課長 @製品開発部　機械設計グループ
#   |-- 佐藤リーダー（新規開発業務）
#   |     |-- Alice
#   |     |-- Bob
#   |-- 鈴木リーダー（不具合対応業務）
#         |-- 星野
#         |-- 斎藤

USER_PASSWORD = 'test123'

yamada_user = jmd_organization.users.create!(
  name: '山田　太郎',
  email: 'taro.yamada@example.com',
  password: USER_PASSWORD,
)
sato_user = jmd_organization.users.create!(
  name: '佐藤　守',
  email: 'mamoru.sato@example.com',
  password: USER_PASSWORD,
)
alice_user = jmd_organization.users.create!(
  name: 'Alice.W',
  email: 'alice.williams@example.com',
  password: USER_PASSWORD,
)
bob_user = jmd_organization.users.create!(
  name: 'Bob.J',
  email: 'bob.johnson@example.com',
  password: USER_PASSWORD,
)
suzuki_user = jmd_organization.users.create!(
  name: '鈴木　咲',
  email: 'saki.suzuki@example.com',
  password: USER_PASSWORD,
)
hoshino_user = jmd_organization.users.create!(
  name: '星野　結衣',
  email: 'yui.hoshino@example.com',
  password: USER_PASSWORD,
)
saito_user = jmd_organization.users.create!(
  name: '斎藤　修',
  email: 'osamu.saito@example.com',
  password: USER_PASSWORD,
)

# 神奈川製鉄株式会社
tanaka_user = kanagawa_steel_organization.users.create!(
  name: '田中　花子',
  email: 'hanako.tanaka@example.com',
  password: USER_PASSWORD,
)

# 無所属
User.create!(
  name: '山下　次郎',
  email: 'jiro.yamashita@example.com',
  password: USER_PASSWORD,
)

puts '==================== creating project ===================='

# 新規開発業務
noise_reduction_project = jmd_organization.projects.create!(
  name: '機構Aの騒音低減',
  description: '【保留】製品Aの機構Aの動作音の低減。改善要望がほとんどないため、保留。次世代機で対応する方針。',
  is_done: false,
  is_archived: true,
  users: [yamada_user, sato_user, bob_user]
)
product_development_project = jmd_organization.projects.create!(
  name: '製品Bの開発',
  description: '大規模病院向けの製品Bの開発。',
  is_done: false,
  is_archived: false,
  users: [yamada_user, sato_user, bob_user, alice_user]
)
safety_regulations_project = jmd_organization.projects.create!(
  name: '安全法令Aの対応',
  description: '20XX年XX月に施行される海外の安全法令Aの対応。設けられた安全基準に対し、全件対応必須。対象装置は、法令適用後に出荷されるもの全て。',
  is_done: false,
  is_archived: false,
  users: [yamada_user, sato_user, alice_user]
)

# 不具合対応業務
cable_disconnection_project = jmd_organization.projects.create!(
  name: '機構Aのコード断線対応',
  description: 'A医療センターで発生した、製品Aの機構Aのコード断線の対応。',
  is_done: true,
  is_archived: true,
  users: [yamada_user, suzuki_user, hoshino_user]
)
arm_breaking_project = jmd_organization.projects.create!(
  name: '機構Bのアーム破損対応',
  description: 'B市民病院で発生した、製品Aの機構Bのアーム破損の対応。',
  is_done: false,
  is_archived: false,
  users: [yamada_user, suzuki_user, hoshino_user]
)
sensor_false_detection_project = jmd_organization.projects.create!(
  name: '機構Cのセンサ誤検知対応',
  description: 'C大学付属病院で発生した、製品Aの機構Cのセンサ誤検知の対応。',
  is_done: true,
  is_archived: false,
  users: [yamada_user, suzuki_user, saito_user]
)

# 神奈川製鉄株式会社
material_research_project = kanagawa_steel_organization.projects.create!(
  name: '高強度かつ軽量な材料の研究',
  is_done: false,
  is_archived: false,
  users: [tanaka_user]
)
car_frame_project = kanagawa_steel_organization.projects.create!(
  name: '自動車フレームの開発',
  is_done: true,
  is_archived: true,
  users: [tanaka_user]
)

puts '==================== creating task ===================='

THIS_MONDAY = Time.zone.today.beginning_of_week
THIS_FRIDAY = THIS_MONDAY.next_occurring(:friday)

noise_reduction_project.tasks.create!(
  name: '騒音の原因の特定',
  start_at: nil,
  end_at: nil,
  description: '',
  is_done: false,
  row_order: 1
)

product_development_project.tasks.create!(
  name: '3Dモデル設計',
  start_at: THIS_MONDAY.weeks_ago(6),
  end_at: THIS_FRIDAY.weeks_ago(1),
  description: '筐体と機構を優先すること。',
  is_done: true,
  row_order: 1
)
product_development_project.tasks.create!(
  name: '図面作成',
  start_at: THIS_MONDAY,
  end_at: THIS_FRIDAY.weeks_since(1),
  description: '',
  is_done: false,
  row_order: 2
)
product_development_project.tasks.create!(
  name: '部品手配',
  start_at: THIS_MONDAY.weeks_since(1),
  end_at: THIS_FRIDAY.weeks_since(1),
  description: '4台分手配。手配可能なものがあれば順次手配する。',
  is_done: false,
  row_order: 3
)
product_development_project.tasks.create!(
  name: '組立',
  start_at: THIS_MONDAY.weeks_since(6),
  end_at: THIS_FRIDAY.weeks_since(7),
  description: '',
  is_done: false,
  row_order: 4
)
product_development_project.tasks.create!(
  name: '設計検証',
  start_at: THIS_MONDAY.weeks_since(8),
  end_at: THIS_FRIDAY.weeks_since(11),
  description: '',
  is_done: false,
  row_order: 5
)
product_development_project.tasks.create!(
  name: 'QAへの入検',
  start_at: THIS_MONDAY.weeks_since(12),
  end_at: THIS_FRIDAY.weeks_since(15),
  description: '',
  is_done: false,
  row_order: 6
)

safety_regulations_project.tasks.create!(
  name: '設計変更内容のピックアップ',
  start_at: THIS_MONDAY.weeks_ago(8),
  end_at: THIS_FRIDAY.weeks_ago(8),
  description: '',
  is_done: true,
  row_order: 1
)
safety_regulations_project.tasks.create!(
  name: '3Dモデル設計',
  start_at: THIS_MONDAY.weeks_ago(7),
  end_at: THIS_FRIDAY.weeks_ago(6),
  description: '',
  is_done: true,
  row_order: 2
)
safety_regulations_project.tasks.create!(
  name: '図面作成',
  start_at: THIS_MONDAY.weeks_ago(5),
  end_at: THIS_FRIDAY.weeks_ago(5),
  description: '',
  is_done: true,
  row_order: 3
)
safety_regulations_project.tasks.create!(
  name: '部品手配',
  start_at: THIS_MONDAY.weeks_ago(5).next_occurring(:thursday),
  end_at: THIS_FRIDAY.weeks_ago(5),
  description: '',
  is_done: true,
  row_order: 4
)
safety_regulations_project.tasks.create!(
  name: '設計検証',
  start_at: THIS_MONDAY.weeks_ago(1),
  end_at: THIS_FRIDAY,
  description: '',
  is_done: false,
  row_order: 5
)
safety_regulations_project.tasks.create!(
  name: 'QAへの入検',
  start_at: THIS_MONDAY.weeks_since(1),
  end_at: THIS_FRIDAY.weeks_since(1),
  description: '',
  is_done: false,
  row_order: 6
)
safety_regulations_project.tasks.create!(
  name: '変更連絡書の発行',
  start_at: THIS_MONDAY.weeks_since(3),
  end_at: THIS_FRIDAY.weeks_since(3),
  description: '',
  is_done: false,
  row_order: 7
)

cable_disconnection_project.tasks.create!(
  name: '不具合原因調査',
  start_at: THIS_MONDAY.weeks_ago(15),
  end_at: THIS_FRIDAY.weeks_ago(14),
  description: '',
  is_done: true,
  row_order: 1
)
cable_disconnection_project.tasks.create!(
  name: '試作手配',
  start_at: THIS_MONDAY.weeks_ago(13),
  end_at: THIS_FRIDAY.weeks_ago(13),
  description: '',
  is_done: true,
  row_order: 2
)
cable_disconnection_project.tasks.create!(
  name: '設計検証',
  start_at: THIS_MONDAY.weeks_ago(7),
  end_at: THIS_FRIDAY.weeks_ago(6),
  description: '',
  is_done: true,
  row_order: 3
)
cable_disconnection_project.tasks.create!(
  name: 'QAへの入検',
  start_at: THIS_MONDAY.weeks_ago(5),
  end_at: THIS_FRIDAY.weeks_ago(5),
  description: '',
  is_done: true,
  row_order: 4
)
cable_disconnection_project.tasks.create!(
  name: '変更連絡書の発行',
  start_at: THIS_MONDAY.weeks_ago(3),
  end_at: THIS_FRIDAY.weeks_ago(3),
  description: '',
  is_done: true,
  row_order: 5
)

arm_breaking_project.tasks.create!(
  name: '不具合原因調査',
  start_at: THIS_MONDAY.weeks_ago(2),
  end_at: THIS_FRIDAY,
  description: '',
  is_done: false,
  row_order: 1
)
arm_breaking_project.tasks.create!(
  name: '試作手配',
  start_at: THIS_MONDAY.weeks_since(1),
  end_at: THIS_FRIDAY.weeks_since(1),
  description: '',
  is_done: false,
  row_order: 2
)
arm_breaking_project.tasks.create!(
  name: '設計検証',
  start_at: THIS_MONDAY.weeks_since(5),
  end_at: nil,
  description: '',
  is_done: false,
  row_order: 3
)
arm_breaking_project.tasks.create!(
  name: 'QAへの入検',
  start_at: nil,
  end_at: THIS_FRIDAY.weeks_since(12),
  description: '',
  is_done: false,
  row_order: 4
)
arm_breaking_project.tasks.create!(
  name: '変更連絡書の発行',
  start_at: nil,
  end_at: nil,
  description: '',
  is_done: false,
  row_order: 5
)

sensor_false_detection_project.tasks.create!(
  name: '不具合原因調査',
  start_at: THIS_MONDAY.weeks_ago(13),
  end_at: THIS_FRIDAY.weeks_ago(12),
  description: '',
  is_done: true,
  row_order: 1
)
sensor_false_detection_project.tasks.create!(
  name: '試作手配',
  start_at: THIS_MONDAY.weeks_ago(11),
  end_at: THIS_FRIDAY.weeks_ago(11),
  description: '',
  is_done: true,
  row_order: 2
)
sensor_false_detection_project.tasks.create!(
  name: '設計検証',
  start_at: THIS_MONDAY.weeks_ago(5),
  end_at: THIS_FRIDAY.weeks_ago(4),
  description: '',
  is_done: true,
  row_order: 3
)
sensor_false_detection_project.tasks.create!(
  name: 'QAへの入検',
  start_at: THIS_MONDAY.weeks_ago(3),
  end_at: THIS_FRIDAY.weeks_ago(3),
  description: '',
  is_done: true,
  row_order: 4
)
sensor_false_detection_project.tasks.create!(
  name: '変更連絡書の発行',
  start_at: THIS_MONDAY.weeks_ago(1),
  end_at: THIS_FRIDAY.weeks_ago(1),
  description: '',
  is_done: true,
  row_order: 5
)

# 神奈川製鉄株式会社
material_research_project.tasks.create!(
  name: 'CFRPの組成検討',
  start_at: THIS_MONDAY.weeks_ago(4),
  end_at: THIS_FRIDAY.weeks_since(8),
  description: '',
  is_done: false,
  row_order: 1
)
car_frame_project.tasks.create!(
  name: '抗酸化皮膜の耐久試験',
  start_at: THIS_MONDAY.weeks_ago(2),
  end_at: THIS_FRIDAY.weeks_ago(1),
  description: '',
  is_done: true,
  row_order: 1
)
