module TasksHelper
  # 各月の開始日、およびそのグリッドを抽出する。
  #
  # @param [Array<Date>] continuous_dates 連続した日付の配列。
  # @return [Array<Array<Date, Integer>>] 各月の開始日、およびそのグリッドからなる配列。
  def filter_month_start_dates_with_grid(continuous_dates)
    first_date = continuous_dates.first
    (
      first_date == first_date.beginning_of_month ? [] : [[first_date, 1]]
    ) + continuous_dates.filter_map.with_index do |date, index|
      [date, index + 1] if date.day == 1
    end
  end

  # 基準の日付配列に対応する、指定期間のgrid-columnを算出する。
  #
  # @param base_dates [Array<Date>] 基準gridとなる日付の配列。
  # @param start_date [Date] カラムを求めたい期間の開始日。
  # @param end_date [Date] カラムを求めたい期間の終了日。
  # @param known_start_grid [Integer] 開始grid。計算量削減のため、既知の場合は指定する。
  # @param known_end_grid [Integer] 終了grid。計算量削減のため、既知の場合は指定する。
  # @return [String] grid-column。または、display: none。
  # @raise [RuntimeError] 終了日が開始日より前の場合。
  def calculate_grid_column(
    base_dates, start_date, end_date, known_start_grid: nil, known_end_grid: nil
  )
    if start_date.nil? || end_date.nil?
      return "display: none;"
    end

    raise 'end_dateはstart_date以降にしてください。' if end_date < start_date

    if end_date < base_dates.first || start_date > base_dates.last
      return "display: none;"
    end

    column_width_in_grids = 1

    start_grid =
      if known_start_grid
        known_start_grid
      elsif start_date < base_dates.first
        start_date = base_dates.first
        1
      elsif known_end_grid # base_datesの長さが長い場合における計算量削除のため
        end_grid - column_width_in_grids - (end_date - start_date).to_i
      else
        base_dates.find_index(start_date) + 1
      end

    end_grid =
      if known_end_grid
        known_end_grid
      elsif end_date > base_dates.last
        -1
      else
        start_grid + column_width_in_grids + (end_date - start_date).to_i
      end

    "grid-column: #{start_grid} / #{end_grid};"
  end

  # @param date [Date]
  # @return [Boolean]
  def weekend?(date)
    date.wday == 0 || date.wday == 6
  end
end
