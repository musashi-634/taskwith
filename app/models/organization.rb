class Organization < ApplicationRecord
  has_many :users

  has_many :projects, dependent: :destroy

  validates :name, presence: true

  def self.create_with_admin(attributes, user)
    organization = nil
    transaction do
      organization = Organization.create(attributes.merge({ users: [user] }))
      raise ActiveRecord::Rollback if organization.errors.present? # 例外をブロック外に出さずにロールバック
      user.update!(is_admin: true)
    end
    organization
  end
end
