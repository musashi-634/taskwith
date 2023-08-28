class User < ApplicationRecord
  belongs_to :organization, optional: true

  has_many :project_members, dependent: :destroy
  has_many :projects, through: :project_members

  validates :name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
