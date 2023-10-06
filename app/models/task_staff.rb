class TaskStaff < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :task_id, uniqueness: { scope: :user_id }
end
