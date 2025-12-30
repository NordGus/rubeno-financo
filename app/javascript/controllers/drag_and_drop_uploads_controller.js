import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"

// Connects to data-controller="drag-and-drop-uploads"
export default class extends Controller {
  static targets = ["input", "dropzone"]
  static values = { url: String, uploadUrl: String, parentableType: String, parentableId: Number }

  connect() {
    this.dropzoneTarget.addEventListener("dragover", this.preventDrag.bind(this))
    this.dropzoneTarget.addEventListener("drop", this.drop.bind(this))
    this.dropzoneTarget.addEventListener("dragleave", this.drop.bind(this))
  }

  disconnect() {
    this.dropzoneTarget.removeEventListener("dragover", this.preventDrag.bind(this))
    this.dropzoneTarget.removeEventListener("drop", this.drop.bind(this))
    this.dropzoneTarget.removeEventListener("dragleave", this.drop.bind(this))
  }

  preventDrag(event) {
    event.preventDefault()
    event.stopPropagation()

    if (!this.dropzoneTarget.classList.contains("upload-preview")) this.dropzoneTarget.classList.add("upload-preview")
  }

  dragExited(event) {
    event.preventDefault()

    if (this.dropzoneTarget.classList.contains("upload-preview")) this.dropzoneTarget.classList.remove("upload-preview")
  }

  drop(event) {
    this.preventDrag(event)
    if (this.dropzoneTarget.classList.contains("upload-preview")) this.dropzoneTarget.classList.remove("upload-preview")

    const files = event.dataTransfer.files
    Array.from(files).forEach(file => this.uploadFile(file))
  }

  uploadFile(file) {
    const direct_upload = new DirectUpload(file, "/file_system/item/files/upload")

    direct_upload.create((error, blob) => {
      if (error) {
        console.error(error)

        this.element.classList.remove("upload-preview")
      } else {
        this.#createFileEntry(blob.signed_id).then()
      }
    })
  }

  async #createFileEntry(signed_id) {
    await fetch(this.urlValue, {
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
  }
}
