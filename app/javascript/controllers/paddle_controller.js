import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form" ]

  connect() {
    let params = {
      method: 'inline',
      allowQuantity: false,
      disableLogout: true,
      frameTarget: "paddle-checkout",
      frameInitialHeight: 416,
      frameStyle: 'width:100%; background-color: transparent; border: none;',
      successCallback: this.checkoutComplete.bind(this)
    }

    if (this.data.get("action") == "create-subscription") {
      Paddle.Checkout.open({
        ...params,
        product: this.data.get("product"),
        email: this.data.get("email"),
        passthrough: this.data.get("passthrough")
      });
    } else if (this.data.get("action") == "update-payment-details") {
      Paddle.Checkout.open({
        ...params,
        override: this.data.get("update-url")
      });
    }
  }

  checkoutComplete(data) {
    this.addHiddenField("processor", "paddle")
    // Webhooks will set the customer ID and subscription using the `passthrough` parameter
    Rails.fire(this.formTarget, "submit")
  }

  addHiddenField(name, value) {
    let hiddenInput = document.createElement("input")
    hiddenInput.setAttribute("type", "hidden")
    hiddenInput.setAttribute("name", name)
    hiddenInput.setAttribute("value", value)
    this.formTarget.appendChild(hiddenInput)
  }
}
