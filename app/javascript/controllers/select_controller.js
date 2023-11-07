import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"


export default class extends Controller {
  connect() {
    this.tomSelect = new TomSelect(this.element, {
      hidePlaceholder: true,
    });
  }

  disconnect() {
    this.tomSelect.destroy();
  }
}
