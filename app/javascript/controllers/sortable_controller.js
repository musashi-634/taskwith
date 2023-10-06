import { Controller } from "@hotwired/stimulus"
import { Sortable } from "sortablejs"
import { patch } from '@rails/request.js'

export default class extends Controller {
  static values = { url: String };

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      onEnd: this.onEnd.bind(this),
    });
  }

  disconnect() {
    this.sortable.destroy();
  }

  onEnd(event) {
    const { newIndex, item } = event;
    const id = item.dataset.sortableId;
    const url = this.urlValue.replace(":id", id);
    patch(url, {
      body: JSON.stringify({ row_order_position: newIndex }),
    });
  }
}
