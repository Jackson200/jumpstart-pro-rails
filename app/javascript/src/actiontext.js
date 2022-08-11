import Trix from "trix"
import "@rails/actiontext"
import { get } from "@rails/request.js"

Trix.config.textAttributes.inlineCode = {
  tagName: "code",
  inheritable: true
}

class EmbedController {
  constructor(element) {
    this.patterns = undefined
    this.element = element
    this.editor = element.editor
    this.toolbar = element.toolbarElement

    this.injectHTML()

    this.hrefElement = this.toolbar.querySelector("[data-trix-input][name='href']")
    this.embedContainerElement = this.toolbar.querySelector("[data-behavior='embed_container']")
    this.embedElement = this.toolbar.querySelector("[data-behavior='embed_url']")

    this.reset()
    this.installEventHandlers()
  }

  injectHTML() {
    this.toolbar.querySelector('[data-trix-dialog="href"]').insertAdjacentHTML('beforeend', `
        <div data-behavior="embed_container">
          <div class="link_to_embed link_to_embed--new">
            Would you like to embed media from this site?
            <input class="btn btn-tertiary btn-small outline" type="button" data-behavior="embed_url" value="Yes, embed it">
          </div>
        </div>
    `)
  }

  installEventHandlers() {
    this.hrefElement.addEventListener("input", this.didInput.bind(this))
    this.hrefElement.addEventListener("focusin", this.didInput.bind(this))
    this.embedElement.addEventListener("click", this.embed.bind(this))
  }

  didInput(event) {
    let value = event.target.value.trim()

    // Load patterns from server so we can dynamically update them
    if (this.patterns === undefined) {
      this.loadPatterns(value)

    // When patterns are loaded, we can just fetch the embed code
    } else if (this.match(value)) {
      this.fetch(value)

    // No embed code, just reset the form
    } else {
      this.reset()
    }
  }

  async loadPatterns(value) {
    const response = await get("/action_text/embeds/patterns.json", { responseKind: "json" })
    if (response.ok) {
      const patterns = await response.json
      this.patterns = patterns.map(pattern => new RegExp(pattern.source, pattern.options))
      if (this.match(value)) {
        this.fetch(value)
      }
    }
  }

  // Checks if a url matches an embed code format
  match(value) {
    return this.patterns.some(regex => regex.test(value))
  }

  fetch(value) {
    Rails.ajax({
      url: `/action_text/embeds?id=${encodeURIComponent(value)}`,
      type: 'post',
      error: this.reset.bind(this),
      success: this.showEmbed.bind(this)
    })
  }

  embed(event) {
    if (this.currentEmbed == null) { return }

    let attachment = new Trix.Attachment(this.currentEmbed)
    this.editor.insertAttachment(attachment)
    this.element.focus()
  }

  showEmbed(embed) {
    this.currentEmbed = embed
    this.embedContainerElement.style.display = "block"
  }

  reset() {
    this.embedContainerElement.style.display = "none"
    this.currentEmbed = null
  }
}

class InlineCode {
  constructor(element) {
    this.element = element
    this.editor = element.editor
    this.toolbar = element.toolbarElement

    this.installEventHandlers()
  }

  installEventHandlers() {
    const blockCodeButton = this.toolbar.querySelector("[data-trix-attribute=code]")
    const inlineCodeButton = blockCodeButton.cloneNode(true)

    inlineCodeButton.hidden = true
    inlineCodeButton.dataset.trixAttribute = "inlineCode"
    blockCodeButton.insertAdjacentElement("afterend", inlineCodeButton)

    this.element.addEventListener("trix-selection-change", _ => {
      const type = this.getCodeFormattingType()
      blockCodeButton.hidden = type == "inline"
      inlineCodeButton.hidden = type == "block"
    })
  }

  getCodeFormattingType() {
    if (this.editor.attributeIsActive("code")) return "block"
    if (this.editor.attributeIsActive("inlineCode")) return "inline"

    const range = this.editor.getSelectedRange()
    if (range[0] == range[1]) return "block"

    const text = this.editor.getSelectedDocument().toString().trim()
    return /\n/.test(text) ? "block" : "inline"
  }
}

document.addEventListener("trix-initialize", function(event) {
  new EmbedController(event.target)
  new InlineCode(event.target)
})
