import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileInput", "fileName", "dropzone", "emptyState", "fileState", "saveButton"]

  connect() {
    console.log("✅ Drag & Drop Controller connected!");
    // Store the bound function to be able to remove it later.
    // This is crucial for correctly removing the listener in disconnect.
    this.boundPreventDefaults = this.preventDefaults.bind(this);
    document.addEventListener("dragover", this.boundPreventDefaults);
    document.addEventListener("drop", this.boundPreventDefaults);
  }

  disconnect() {
    document.removeEventListener("dragover", this.boundPreventDefaults);
    document.removeEventListener("drop", this.boundPreventDefaults);
  }

  // This function is called for dragover and drop events on the *entire document*.
  // Its job is to prevent the browser's default behavior, which is to open the dropped file.
  preventDefaults(event) {
    event.preventDefault()
  }

  // Called by data-action on the element when a file is dragged over it.
  highlight(event) {
    console.log("🎯 Highlight triggered");
    event.preventDefault();
    event.stopPropagation();
    this.dropzoneTarget.classList.add("border-primary");
    this.dropzoneTarget.classList.remove("border-base-content/20");
  }

  // Called by data-action on the element when a file is dragged away from it.
  unhighlight(event) {
    if (event) {
      event.preventDefault();
      event.stopPropagation();
    }
    this.dropzoneTarget.classList.remove("border-primary");
    this.dropzoneTarget.classList.add("border-base-content/20");
  }

  // Called by data-action on the element when a file is dropped on it.
  handleDrop(event) {
    console.log("📦 Drop triggered", event.dataTransfer.files);
    event.preventDefault();
    event.stopPropagation();
    this.unhighlight(event);
    const files = event.dataTransfer.files;
    if (files.length > 0) {
      console.log("📁 File detected:", files[0].name);
      this.fileInputTarget.files = files;
      // Manually dispatch change event as setting files property doesn't trigger it
      this.fileInputTarget.dispatchEvent(new Event('change', { bubbles: true }));
    }
  }

  // Called by data-action when the element is clicked.
  triggerFileInput(event) {
    console.log("👆 Click triggered on dropzone");
    // Don't preventDefault here - it blocks the file input click
    event.stopPropagation();
    console.log("🖱️ Opening file dialog...");
    this.fileInputTarget.click();
  }

  // Called by data-action when the file input's value changes.
  handleFileChange() {
    if (this.fileInputTarget.files.length > 0) {
      this.fileNameTarget.textContent = this.fileInputTarget.files[0].name;
      console.log("Selected file:", this.fileInputTarget.files[0]);
      this.showFileState();
    } else {
      this.showEmptyState();
    }
  }

  // Show the file selected state
  showFileState() {
    this.emptyStateTarget.classList.add("hidden");
    this.fileStateTarget.classList.remove("hidden");
    this.saveButtonTarget.classList.remove("hidden");
  }

  // Show the empty state (no file selected)
  showEmptyState() {
    this.emptyStateTarget.classList.remove("hidden");
    this.fileStateTarget.classList.add("hidden");
    this.saveButtonTarget.classList.add("hidden");
    this.fileNameTarget.textContent = "";
  }

  // Remove the selected file
  removeFile(event) {
    event.preventDefault();
    event.stopPropagation();
    console.log("🗑️ Removing file");
    this.fileInputTarget.value = "";
    this.showEmptyState();
  }

  // Save the file (placeholder - backend not yet implemented)
  saveFile(event) {
    event.preventDefault();
    console.log("💾 Save file clicked - backend not yet implemented");
    console.log("File to save:", this.fileInputTarget.files[0]);

    // TODO: Implement backend upload
    // For now, just show a message
    alert("Save functionality will be implemented in the backend. File selected: " + this.fileInputTarget.files[0].name);
  }
}