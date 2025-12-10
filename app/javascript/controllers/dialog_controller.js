import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dialog"
export default class extends Controller {
  connect() {
  }

  open(event) {
    event.preventDefault()
    const dialog_name = event.currentTarget.dataset.dialog
    const dialog = this.element.getElementsByTagName("dialog").namedItem(dialog_name)

    dialog.showModal()
  }

  close(event) {
    event.preventDefault()

    event.currentTarget.closest("dialog").close()
  }
}
