JAPANESE_DAYS_OF_WEEK = %w(日 月 火 水 木 金 土)

Date::DATE_FORMATS[:month] = '%Y/%-m'
Date::DATE_FORMATS[:date] = '%Y/%-m/%-d'
Date::DATE_FORMATS[:japanese_day_of_week] = ->(date) { JAPANESE_DAYS_OF_WEEK[date.strftime('%w').to_i] }
