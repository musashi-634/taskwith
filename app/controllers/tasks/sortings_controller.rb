class Tasks::SortingsController < ApplicationController
  before_action :set_task, only: :update
  before_action -> { block_user_belongs_to_other_organization(@task) }

  def update
    @task.update(row_order_position: params[:row_order_position])
    head :no_content
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
