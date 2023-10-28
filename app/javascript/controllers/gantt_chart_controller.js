import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "today", "chart" ]
  static values = { offsetDay: Number }

  connect() {
    this.scrollToTodayAmount = this.calcScrollToTodayAmount();
    this.scrollToToday();
  }

  calcScrollToTodayAmount() {
    const offsetWidth = this.todayTarget.offsetWidth;
    const styles = getComputedStyle(this.todayTarget);
    const marginRight = parseInt(styles.marginRight);
    const marginLeft = parseInt(styles.marginLeft);
    const gridColumnStart = parseInt(styles.gridColumnStart);

    return (offsetWidth + marginRight + marginLeft) * (gridColumnStart - 1 + this.offsetDayValue);
  }

  scrollToToday() {
    this.chartTarget.scrollLeft = this.scrollToTodayAmount
  }
}
