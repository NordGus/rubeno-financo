import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"

// Connects to data-controller="drag-and-drop-uploads"
export default class extends Controller {
  static targets = ["input"]
  static values = { url: String, uploadUrl: String, parentableType: String, parentableId: Number }

  connect() {
    this.element.addEventListener("dragover", this.preventDrag.bind(this))
    this.element.addEventListener("drop", this.drop.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("dragover", this.preventDrag.bind(this))
    this.element.removeEventListener("drop", this.drop.bind(this))
  }

  preventDrag(event) {
    event.preventDefault()
    event.stopPropagation()

    if (!this.element.classList.contains("upload-preview")) this.element.classList.add("upload-preview")
  }

  drop(event) {
    this.preventDrag(event)
    const files = event.dataTransfer.files
    Array.from(files).forEach(file => this.uploadFile(file))
  }

  uploadFile(file) {
    const direct_upload = new DirectUpload(file, "/rails/active_storage/direct_uploads")

    direct_upload.create((error, blob) => {
      if (error) {
        console.error(error)

        this.element.classList.remove("upload-preview")
      } else {
        this.createFileEntry(blob.signed_id)
      }
    })
  }

  createFileEntry(signed_id) {
    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify({
        signed_id,
        parentable_type: this.parentableTypeValue,
        parentable_id: this.parentableIdValue
      })
    })
    .finally(() => {
      if (!this.element.classList.contains("upload-preview")) return

      this.element.classList.remove("upload-preview")
    })
  }
}
