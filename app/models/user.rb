class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  belongs_to :organization, optional: true

  has_many :project_members, dependent: :destroy
  has_many :projects, through: :project_members

  has_many :task_staffs, dependent: :destroy
  has_many :tasks, through: :task_staffs

  validates :name, presence: true
  validates :is_admin, inclusion: [true, false]

  GUEST_EMAIL = 'guest@example.com'.freeze

  def self.guest
    find_or_create_by!(email: GUEST_EMAIL) do |user|
      user.name = 'ゲストユーザー'
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def display_admin_privilege
    is_admin? ? '管理者' : '一般'
  end
end
