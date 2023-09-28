class TasksController < ApplicationController
  before_action :block_user_belongs_to_other_organization

  def index
    @tasks = @project.tasks.rank(:row_order)

    @today = Time.zone.today
    @timeline_dates = create_timeline_dates(@today, 3)
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

  def block_user_belongs_to_other_organization
    if action_name.start_with?(*%w(index new create))
      @project = Project.find(params[:project_id])
      if @project.organization != current_user.organization
        redirect_to projects_path
      end
    end
  end

  def create_timeline_dates(base_date, half_time_span_year)
    start_date = base_date.years_ago(half_time_span_year).beginning_of_month
    end_date = base_date.years_since(half_time_span_year).end_of_month
    (start_date..end_date).to_a
  end
end
