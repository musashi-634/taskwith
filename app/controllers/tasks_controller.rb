class TasksController < ApplicationController
  before_action :set_project, only: %w(index new create)
  before_action -> {
    requested_object = @project || @task
    block_user_belongs_to_other_organization(requested_object)
  }

  def index
    @tasks = @project.tasks.rank(:row_order)

    today = Time.zone.today
    @timeline_dates = create_timeline_dates(today, 3)
    @today_grid_column = @timeline_dates.find_index(today) + 1
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(
      params.require(:task).permit(:name, :start_at, :end_at, :description)
    )
    if @task.save
      flash[:notice] = 'タスクを作成しました。'
      redirect_to project_tasks_path(@project)
    else
      flash.now[:alert] = 'タスクを作成できませんでした。'
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def create_timeline_dates(base_date, half_time_span_year)
    start_date = base_date.years_ago(half_time_span_year).beginning_of_month
    end_date = base_date.years_since(half_time_span_year).end_of_month
    (start_date..end_date).to_a
  end
end
