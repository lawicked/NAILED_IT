import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fileInput", "fileName", "dropzone", "emptyState", "fileState", "saveButton"]

  // Security: File validation constants
  static ALLOWED_TYPES = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
  static ALLOWED_EXTENSIONS = ['.pdf', '.doc', '.docx']
  static MAX_FILE_SIZE = 10 * 1024 * 1024 // 10MB in bytes

  connect() {
    // Security: Use AbortController to prevent memory leaks and race conditions
    // This ensures all event listeners are properly cleaned up on disconnect
    this.abortController = new AbortController();

    // Add event listeners with signal for automatic cleanup
    document.addEventListener("dragover", this.preventDefaults.bind(this), {
      signal: this.abortController.signal
    });

    document.addEventListener("drop", this.preventDefaults.bind(this), {
      signal: this.abortController.signal
    });

    // Initialize debouncing flags
    this.isSaving = false;
    this.isProcessingFile = false;
  }

  disconnect() {
    // Security: Abort all event listeners at once to prevent orphaned listeners
    if (this.abortController) {
      this.abortController.abort();
    }
  }

  // This function is called for dragover and drop events on the *entire document*.
  // Its job is to prevent the browser's default behavior, which is to open the dropped file.
  preventDefaults(event) {
    event.preventDefault()
  }

  // Called by data-action on the element when a file is dragged over it.
  highlight(event) {
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
    event.preventDefault();
    event.stopPropagation();
    this.unhighlight(event);
    const files = event.dataTransfer.files;

    if (files.length > 0) {
      // Security: Validate file before accepting it
      const validation = this.validateFile(files[0]);

      if (!validation.isValid) {
        this.showError(validation.errors.join('\n'));
        return;
      }

      this.fileInputTarget.files = files;
      // Security: Dispatch event with bubbles: false to prevent event interception
      // cancelable: false prevents other handlers from blocking the event
      this.fileInputTarget.dispatchEvent(new Event('change', {
        bubbles: false,
        cancelable: false
      }));
    }
  }

  // Called by data-action when the element is clicked.
  triggerFileInput(event) {
    // Don't preventDefault here - it blocks the file input click
    event.stopPropagation();
    this.fileInputTarget.click();
  }

  // Called by data-action when the file input's value changes.
  handleFileChange() {
    // Security: Prevent race conditions from simultaneous file changes
    if (this.isProcessingFile) {
      return;
    }

    if (this.fileInputTarget.files.length > 0) {
      this.isProcessingFile = true;

      // Security: Validate file before accepting it
      const validation = this.validateFile(this.fileInputTarget.files[0]);

      if (!validation.isValid) {
        this.showError(validation.errors.join('\n'));
        this.fileInputTarget.value = ""; // Reset the input
        this.isProcessingFile = false;
        return;
      }

      // Security: Sanitize filename before displaying to prevent XSS
      const sanitizedName = this.sanitizeFileName(this.fileInputTarget.files[0].name);
      this.fileNameTarget.textContent = sanitizedName;
      this.showFileState();

      this.isProcessingFile = false;
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
    this.fileInputTarget.value = "";
    this.showEmptyState();
  }

  // Save the file (placeholder - backend not yet implemented)
  saveFile(event) {
    event.preventDefault();

    // Security: Prevent rapid successive calls (debouncing)
    // This prevents DoS attacks from rapid clicking and duplicate uploads
    if (this.isSaving) {
      return;
    }

    this.isSaving = true;

    // Minimum 1 second between save attempts
    setTimeout(() => {
      this.isSaving = false;
    }, 1000);

    // TODO: Implement backend upload
    // For now, just show a message
    // Security: Sanitize filename before displaying to prevent XSS
    const sanitizedFileName = this.sanitizeFileName(this.fileInputTarget.files[0].name);
    alert(`Save functionality will be implemented in the backend. File selected: ${sanitizedFileName}`);
  }

  // Security: Validate file type, size, and extension
  validateFile(file) {
    const errors = [];

    // Defense 1: Check file extension (case-insensitive)
    const fileName = file.name.toLowerCase();
    const hasValidExtension = this.constructor.ALLOWED_EXTENSIONS.some(ext => fileName.endsWith(ext));
    if (!hasValidExtension) {
      errors.push(`Invalid file extension. Allowed formats: ${this.constructor.ALLOWED_EXTENSIONS.join(', ')}`);
    }

    // Defense 2: Check MIME type
    if (!this.constructor.ALLOWED_TYPES.includes(file.type)) {
      errors.push(`Invalid file type. Detected type: ${file.type || 'unknown'}`);
    }

    // Defense 3: Check file size
    if (file.size > this.constructor.MAX_FILE_SIZE) {
      const sizeMB = (file.size / (1024 * 1024)).toFixed(2);
      errors.push(`File too large (${sizeMB}MB). Maximum allowed: 10MB`);
    }

    // Defense 4: Check file is not empty
    if (file.size === 0) {
      errors.push('File is empty');
    }

    return {
      isValid: errors.length === 0,
      errors: errors
    };
  }

  // Show error message to user
  showError(message) {
    alert(message);
  }

  // Security: Sanitize filename to prevent XSS and path traversal
  sanitizeFileName(fileName) {
    if (!fileName) return 'unknown';

    // Remove path traversal attempts (../, ..\, etc.)
    let sanitized = fileName.replace(/\.\.[\/\\]/g, '');

    // Remove control characters (ASCII 0-31 and 127)
    sanitized = sanitized.replace(/[\x00-\x1F\x7F]/g, '');

    // Remove special HTML characters that could be used for XSS
    sanitized = sanitized.replace(/[<>"'&]/g, '');

    // Remove leading/trailing whitespace and dots
    sanitized = sanitized.trim().replace(/^\.+|\.+$/g, '');

    // Limit length to prevent buffer overflow attacks
    const maxLength = 255;
    if (sanitized.length > maxLength) {
      // Keep extension intact when truncating
      const lastDotIndex = sanitized.lastIndexOf('.');
      if (lastDotIndex > 0) {
        const extension = sanitized.slice(lastDotIndex);
        const nameWithoutExt = sanitized.slice(0, lastDotIndex);
        sanitized = nameWithoutExt.slice(0, maxLength - extension.length) + extension;
      } else {
        sanitized = sanitized.slice(0, maxLength);
      }
    }

    // Fallback if everything was removed
    return sanitized || 'sanitized_file';
  }
}