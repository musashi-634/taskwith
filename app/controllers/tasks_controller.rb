class TasksController < ApplicationController
  before_action :block_user_belongs_to_other_organization

  def index
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks.order(:row_order)

    @today = Time.zone.today
    @timeline_dates = create_timeline_dates(@today, 3)
  end

  private

  def block_user_belongs_to_other_organization
    if Project.find(params[:project_id]).organization != current_user.organization
      redirect_to projects_path
    end
  end

  def create_timeline_dates(base_date, half_time_span_year)
    start_date = base_date.years_ago(half_time_span_year).beginning_of_month
    end_date = base_date.years_since(half_time_span_year).end_of_month
    (start_date..end_date).to_a
  end
end
