import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["badge", "list", "placeholder", "notification"]
  static values = {
    accountId: String, // Current account ID
    accountUnread: Number, // Unread count for the current account
    totalUnread: Number, // Unread count across all the user's accounts
  }

  connect() {
    this.subscription = consumer.subscriptions.create({ channel: "NotificationChannel" }, {
      connected: this._connected.bind(this),
      disconnected: this._disconnected.bind(this),
      received: this._received.bind(this)
    })

    if (this.hasUnread()) this.showUnreadBadge()
  }

  disconnect() {
    this.subscription.unsubscribe()
  }

  _connected() {
  }

  _disconnected() {
  }

  _received(data) {
    this.totalUnreadValue += 1

    if (data.account_id && data.account_id == this.accountIdValue) {
      this.accountUnreadValue += 1
    }

    // Ignore if user is signed in to a different account
    if (data.account_id && data.account_id != this.accountIdValue) {
      return
    }

    // Regular notifications get added to the navbar
    if (data.html) {
      this.listTarget.insertAdjacentHTML('afterbegin', data.html)
      this.showUnreadBadge()
    }

    // Native notifications trigger a browser notification
    if (data.browser) {
      this.checkPermissionAndNotify(data.browser)
    }
  }

  // Called when the notifications view opens
  open() {
    this.hideUnreadBadge()
    this.markAllAsRead()
  }

  hasUnread() {
    return !!this.accountUnreadValue
  }

  showUnreadBadge() {
    if (this.hasBadgeTarget == false) { return }
    this.badgeTarget.classList.remove("hidden")
  }

  hideUnreadBadge() {
    if (this.hasBadgeTarget == false) { return }
    this.badgeTarget.classList.add("hidden")
  }

  markAllAsRead() {
    let ids = this.notificationTargets.map((target) => target.dataset.id)
    this.subscription.perform("mark_as_read", {ids: ids})

    this.accountUnreadValue = 0
    this.totalUnreadValue -= ids.length
  }

  markAsInteracted(event) {
    let id = event.currentTarget.dataset.id
    if (id == null) return
    this.subscription.perform("mark_as_interacted", {ids: [id]})

    // Uncomment to visually mark notification as interacted
    // event.currentTarget.dataset.interactedAt = new Date()
  }

  // Browser notifications
  checkPermissionAndNotify(data) {
    // Return if not supported
    if (!("Notification" in window)) return

    if (Notification.permission === "granted") {
      this.browserNotification(data)

    } else if (Notification.permission !== "denied") {
      Notification.requestPermission().then((permission) => {
        if (permission === "granted") {
          this.browserNotification(data)
        }
      })
    }
  }

  browserNotification(data) {
    new Notification(data.title, data.options)
  }

  // Automatically sync count to Native apps
  totalUnreadValueChanged() {
    this.syncCountToNative()
  }

  // Automatically sync count to Native apps
  accountUnreadValueChanged() {
    this.syncCountToNative()
  }

  // Update the mobile device with the current unread count
  syncCountToNative() {
    window.TurboNativeBridge.setNotificationCount(this.totalUnreadValue, this.accountUnreadValue)
  }
}
