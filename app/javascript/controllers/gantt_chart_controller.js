import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "today", "chart" ]
  static values = { offsetDay: Number }

  connect() {
    this.scrollToToday();
  }

  scrollToToday() {
    const timelineColumnWidth = this.todayTarget.offsetWidth;
    const todayGridColumn = parseInt(getComputedStyle(this.todayTarget).gridColumnStart);
    this.chartTarget.scrollLeft = timelineColumnWidth * (todayGridColumn - 1 + this.offsetDayValue);
  }
}
