import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "button", "form" ]

  connect() {
    braintree.client.create({
      authorization: this.data.get("clientToken")
    }, this.clientCreated.bind(this))
  }

  disconnect() {
    // Remove the paypal button on disconnect
    this.buttonTarget.querySelector(".paypal-button").remove()
  }

  clientCreated(error, clientInstance) {
    if (error) {
      console.error("Error creating client", error)
      return
    }

    braintree.paypalCheckout.create({
      client: clientInstance
    }, this.paypalCreated.bind(this))
  }

  paypalCreated(paypalCheckoutErr, paypalCheckoutInstance) {
    // Stop if there was a problem creating PayPal Checkout.
    // This could happen if there was a network error or if it's incorrectly
    // configured.
    if (paypalCheckoutErr) {
      console.error('Error creating PayPal Checkout:', paypalCheckoutErr);
      return;
    }

    // Set up PayPal with the checkout.js library
    paypal.Button.render({
      env: this.data.get("env"), // or 'sandbox'

      // https://developer.paypal.com/docs/checkout/how-to/customize-button/#
      style: {
        color: 'gold',  // gold blue silver black
        shape: 'rect',  // shape: pill rect
        size:  'medium', // size: small medium large responsive
        label: 'pay',   // label: checkout credit pay buynow paypal installment
        tagline: false, // tagline: true false
      },

      payment: () => {
        return paypalCheckoutInstance.createPayment({
          // Your PayPal options here. For available options, see
          // http://braintree.github.io/braintree-web/current/PayPalCheckout.html#createPayment
          flow: 'vault',
        })
      },

      onAuthorize: (data, actions) => {
        return paypalCheckoutInstance.tokenizePayment(data, this.paymentMethod.bind(this))
      },

      onCancel: (data) => {
        console.log('checkout.js payment cancelled', JSON.stringify(data, 0, 2));
      },

      onError: (err) => {
        console.error('checkout.js error', err);
      }
    }, this.buttonTarget).then(() => {
      // The PayPal button will be rendered in an html element with the id
      // `paypal-button`. This function will be called when the PayPal button
      // is set up and ready to be used.
    });
  }

  paymentMethod(error, payload) {
    if (error) {
      console.error("Error with payment method:", error)
      return
    }

    this.addHiddenField("processor", "braintree")
    this.addHiddenField("payment_method_token", payload.nonce)

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

