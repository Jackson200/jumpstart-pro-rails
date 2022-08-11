class Bridge {
  // Toggles navbar visibility in browser from Native
  static toggleNavBar() {
    const event = new CustomEvent("toggle-nav-bar")
    window.dispatchEvent(event)
  }

  // Sets the notification count on the app icon and currently visible tab.
  // Passing 0 will remove/clear the badge. Passing null will have no effect.
  static setNotificationCount(icon, tab = icon) {
    this.postMessage("showNotificationBadge", {icon, tab})
  }

  // Sends a message to the native app, if active.
  static postMessage(name, data = {}) {
    // iOS
    window.webkit?.messageHandlers?.nativeApp?.postMessage({name, ...data})

    // Android
    window.nativeApp?.postMessage(JSON.stringify({name, ...data}))
  }
}

// Expose this on the window object so TurboNative can interact with it
window.TurboNativeBridge = Bridge
export default Bridge
