import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirmation-alert"
export default class extends Controller {
  static targets = ["dialog"]

  open(event) {
    event.preventDefault()
    this.dialogTarget.showModal()
  }

  cancel(event) {
    event.preventDefault()
    this.dialogTarget.close()
  }

  close(_event) {
    this.dialogTarget.close()
  }
}
