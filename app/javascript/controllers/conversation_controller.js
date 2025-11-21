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
      this.formTarget.requestSubmit()
    }
  }


}
