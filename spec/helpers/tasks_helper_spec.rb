require 'rails_helper'

RSpec.describe TasksHelper, type: :helper do
  describe '#filter_month_start_dates_with_grid' do
    context '配列の最初の日付が1日の場合' do
      let(:dates) { ('2023/7/1'.to_date..'2023/8/31'.to_date).to_a }

      it '各月の1日、およびそのグリッド番号の配列を返すこと' do
        expect(
          helper.filter_month_start_dates_with_grid(dates)
        ).to eq [
          ['2023/7/1'.to_date, 1],
          ['2023/8/1'.to_date, 32],
        ]
      end
    end

    context '配列の最初の日付が1日でない場合' do
      let(:dates) { ('2023/7/2'.to_date..'2023/8/31'.to_date).to_a }

      it '入力の配列における各月の開始日、およびそのグリッド番号の配列を返すこと' do
        expect(
          helper.filter_month_start_dates_with_grid(dates)
        ).to eq [
          ['2023/7/2'.to_date, 1],
          ['2023/8/1'.to_date, 31],
        ]
      end
    end
  end

  describe '#calculate_grid_column' do
    let(:base_dates) { '2023/7/1'.to_date.all_month.to_a }

    context '開始日 <= 終了日 の場合' do
      context '指定した期間が元となる期間内の場合' do
        let(:start_date) { base_dates.first }
        let(:end_date) { base_dates.last }

        it '指定した期間に対応するグリッド範囲を返すこと' do
          expect(
            helper.calculate_grid_column(base_dates, start_date, end_date)
          ).to eq 'grid-column: 1 / 32;'
        end
      end

      context '開始日が元となる期間より前の場合' do
        let(:start_date) { base_dates.first - 1 }
        let(:end_date) { base_dates.first }

        it '開始グリッドが1となったグリッド範囲を返すこと' do
          expect(
            helper.calculate_grid_column(base_dates, start_date, end_date)
          ).to eq 'grid-column: 1 / 2;'
        end
      end

      context '終了日が元となる期間より後の場合' do
        let(:start_date) { base_dates.last }
        let(:end_date) { base_dates.last + 1 }

        it '終了グリッドが-1となったグリッド範囲を返すこと' do
          expect(
            helper.calculate_grid_column(base_dates, start_date, end_date)
          ).to eq 'grid-column: 31 / -1;'
        end
      end

      context '終了日が元となる期間より前の場合' do
        let(:end_date) { base_dates.first - 1 }
        let(:start_date) { end_date }

        it '「display: none;」を返すこと' do
          expect(
            helper.calculate_grid_column(base_dates, start_date, end_date)
          ).to eq 'display: none;'
        end
      end

      context '開始日が元となる期間より後の場合' do
        let(:start_date) { base_dates.last + 1 }
        let(:end_date) { start_date }

        it '「display: none;」を返すこと' do
          expect(
            helper.calculate_grid_column(base_dates, start_date, end_date)
          ).to eq 'display: none;'
        end
      end
    end

    context '開始日 > 終了日 の場合' do
      let(:start_date) { base_dates.last }
      let(:end_date) { start_date - 1 }

      it 'エラーが発生すること' do
        expect do
          helper.calculate_grid_column(base_dates, start_date, end_date)
        end.to raise_error 'end_dateはstart_date以降にしてください。'
      end
    end

    context '開始日がnilの場合' do
      let(:start_date) { nil }
      let(:end_date) { base_dates.first }

      it '「display: none;」を返すこと' do
        expect(
          helper.calculate_grid_column(base_dates, start_date, end_date)
        ).to eq 'display: none;'
      end
    end

    context '終了日がnilの場合' do
      let(:start_date) { base_dates.first }
      let(:end_date) { nil }

      it '「display: none;」を返すこと' do
        expect(
          helper.calculate_grid_column(base_dates, start_date, end_date)
        ).to eq 'display: none;'
      end
    end
  end

  describe '#weekend?' do
    let(:date) { '2023/7/1'.to_date }

    context '引数に休日を渡した場合' do
      let(:weekends) { [date.next_week(:saturday), date.next_week(:sunday)] }

      it 'trueを返すこと' do
        expect(
          weekends.map { |weekend| helper.weekend?(weekend) }
        ).to eq [true, true]
      end
    end

    context '引数に平日を渡した場合' do
      let(:weekdays) { (date.next_week(:monday)..date.next_week(:friday)).to_a }

      it 'falseを返すこと' do
        expect(
          weekdays.map { |weekday| helper.weekend?(weekday) }
        ).to eq [false, false, false, false, false]
      end
    end
  end
end
