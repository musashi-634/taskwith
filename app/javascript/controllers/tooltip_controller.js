import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // See https://getbootstrap.jp/docs/5.0/components/tooltips/#example-enable-tooltips-everywhere
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
    })
  }
}
