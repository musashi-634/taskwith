class Task < ApplicationRecord
  include RankedModel

  belongs_to :project
  ranks :row_order,
    with_same: :project_id # projectごとにscopeを絞ってランク付け

  has_many :task_staffs, dependent: :destroy
  has_many :users, through: :task_staffs
  validates :user_ids, inclusion: { in: ->(task) { task.project.user_ids } }

  validates :name, presence: true
  validate :check_period
  validates :is_done, inclusion: [true, false]

  delegate :organization, to: :project

  def display_done_state
    is_done ? '完了' : '未完了'
  end

  private

  def check_period
    if start_at.nil? || end_at.nil?
      return
    end

    if start_at > end_at
      errors.add(:end_at, "は開始日以降にしてください")
    end
  end
end
