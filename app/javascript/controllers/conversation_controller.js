import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="conversation"
export default class extends Controller {
  static targets = ["messages", "form", "textarea", "submit", "loadingIndicator"]

  connect() {
    this.scrollToBottom()

    // Focus on textarea when page loads
    if (this.hasTextareaTarget) {
      this.textareaTarget.focus()
    }

    // Add smooth scroll behavior
    if (this.hasMessagesTarget) {
      this.messagesTarget.style.scrollBehavior = 'smooth'
    }
  }

  // Auto-scroll to bottom of messages
  scrollToBottom() {
    if (this.hasMessagesTarget) {
      setTimeout(() => {
        this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
      }, 100)
    }
  }

  // Handle Enter key to send (Shift+Enter for new line)
  handleKeydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.submitForm()
    }
  }

  // Submit the form
  submitForm() {
    if (this.textareaTarget.value.trim() === "") {
      return
    }

    // Disable form while submitting
    this.setLoadingState(true)

    // Submit the form
    this.formTarget.requestSubmit()
  }

  // Set loading state
  setLoadingState(isLoading) {
    if (this.hasSubmitTarget) {
      this.submitTarget.disabled = isLoading

      if (isLoading) {
        this.submitTarget.classList.add("loading")
        this.textareaTarget.disabled = true

        // Show loading indicator
        if (this.hasLoadingIndicatorTarget) {
          this.loadingIndicatorTarget.classList.remove("hidden")
        }
      } else {
        this.submitTarget.classList.remove("loading")
        this.textareaTarget.disabled = false

        // Hide loading indicator
        if (this.hasLoadingIndicatorTarget) {
          this.loadingIndicatorTarget.classList.add("hidden")
        }
      }
    }
  }

  // Auto-resize textarea as user types
  autoResize(event) {
    const textarea = event.target
    textarea.style.height = 'auto'
    const newHeight = Math.min(textarea.scrollHeight, 300)
    textarea.style.height = newHeight + 'px'
  }

  // Clear form after successful submission
  clearForm() {
    if (this.hasTextareaTarget) {
      this.textareaTarget.value = ""
      this.textareaTarget.style.height = 'auto'
      this.textareaTarget.focus()
    }
    this.setLoadingState(false)
    this.scrollToBottom()
  }

  // Handle form submission response
  afterSubmit(event) {
    if (event.detail.success) {
      this.clearForm()
    } else {
      this.setLoadingState(false)
    }
  }
}
