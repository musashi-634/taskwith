class User < ApplicationRecord
  belongs_to :organization, optional: true

  has_many :project_members, dependent: :destroy
  has_many :projects, through: :project_members

  has_many :task_staffs, dependent: :destroy
  has_many :tasks, through: :task_staffs

  validates :name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable
end
