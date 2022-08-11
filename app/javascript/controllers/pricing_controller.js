// Options:
//
// Use data-pricing-active="yearly" to select yearly by default

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "toggle", "frequency", "plans" ]

  connect() {
    // Classes toggle on the plan switcher items
    this.activeFrequencyClass   = (this.data.get("active-frequency-class") || "bg-white shadow-sm text-black hover:text-black").split(" ")
    this.inactiveFrequencyClass = (this.data.get("inactive-frequency-class") || "hover:text-gray-900").split(" ")

    // Classes toggle on the plans
    this.activePlansClass   = (this.data.get("activePlansClass") || "flex").split(" ")
    this.inactivePlansClass = (this.data.get("inactivePlansClass") || "hidden").split(" ")

    // Remove any targets without plans in them
    this.frequencyTargets.forEach(target => {
      let frequency = target.dataset.frequency
      let index = this.plansTargets.findIndex((element) => element.dataset.frequency == frequency && element.childElementCount > 0)
      if (index == -1) target.remove()
    })

    // Hide frequency toggle if we have less than 2 frequencies with plans
    if (this.frequencyTargets.length < 2) this._hideFrequencyToggle()

    let frequency = this.data.get("active") || this.frequencyTargets[0].dataset.frequency
    this._toggle(frequency)
  }

  // Switches visible plans
  switch(event) {
    event.preventDefault()
    this._toggle(event.target.dataset.frequency)
  }

  // Hides frequency toggle
  _hideFrequencyToggle() {
    this.toggleTarget.classList.add("hidden")
  }

  // Toggles visible plans and selected frequency
  // Expects: "monthly", "yearly", etc
  _toggle(frequency) {
    // Keep track of active frequency on a data attribute
    this.data.set("active", frequency)

    this.frequencyTargets.forEach(target => {
      if (target.dataset.frequency == frequency) {
        this.showFrequency(target)
      } else {
        this.hideFrequency(target)
      }
    })

    this.plansTargets.forEach(target => {
      if (target.dataset.frequency == frequency) {
        this.showPlans(target)
      } else {
        this.hidePlans(target)
      }
    })
  }

  showFrequency(element) {
    element.classList.add(...this.activeFrequencyClass)
    element.classList.remove(...this.inactiveFrequencyClass)
  }

  hideFrequency(element) {
    element.classList.remove(...this.activeFrequencyClass)
    element.classList.add(...this.inactiveFrequencyClass)
  }

  showPlans(element) {
    element.classList.add(...this.activePlansClass)
    element.classList.remove(...this.inactivePlansClass)
  }

  hidePlans(element) {
    element.classList.remove(...this.activePlansClass)
    element.classList.add(...this.inactivePlansClass)
  }
}
