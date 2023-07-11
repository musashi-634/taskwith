module TasksHelper
  def filter_first_day_of_month_with_grid(timeline_dates)
    timeline_dates.filter_map.with_index { |date, index| [date, index + 1] if date.day == 1 }
  end

  def calculate_end_grid(start_grid, start_date, end_date)
    column_width_in_grids = 1
    start_grid + column_width_in_grids + (end_date - start_date).to_i
  end

  def calculate_grid_column_in_timeline(timeline_dates, start_date, end_date)
    start_grid = timeline_dates.find_index(start_date) + 1
    end_grid = calculate_end_grid(start_grid, start_date, end_date)
    "#{start_grid} / #{end_grid}"
  end

  def weekend?(date)
    date.wday == 0 || date.wday == 6
  end
end
