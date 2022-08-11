// The BulkController can be used for adding bulk operations to your index views.
// You can add a Select All checkbox and checkboxes for each record and easily grab
// the selected records.
//
// Usage:
//
//   import BulkController from "controllers/bulk_controller"
//
//   export default class extends BulkController {
//   }

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = [ "checkbox", "selectAll" ]

  // Toggles all checkboxes based upon what is currently checked
  toggleSelectAll(event) {
    (!this.allCheckboxesSelected) ? this.selectAll() : this.unselectAll()
  }

  // Selects all checkboxes
  selectAll() {
    this.selectAllTarget.checked = true
    this.selectAllTarget.indeterminate = false
    this.unselected.forEach(target => target.checked = true)
  }

  // Unselects all checkboxes
  unselectAll() {
    this.selectAllTarget.checked = false
    this.selectAllTarget.indeterminate = false
    this.selected.forEach(target => target.checked = false)
  }

  // Keep track of SelectAll state based upon how many checkboxes are selected
  change(event) {
    if (this.noCheckboxesSelected) {
      this.selectAllTarget.checked = false
      this.selectAllTarget.indeterminate = false

    } else if (this.allCheckboxesSelected) {
      this.selectAllTarget.checked = true
      this.selectAllTarget.indeterminate = false

    } else {
      this.selectAllTarget.indeterminate = true
    }
  }

  // Returns true if Select All checkbox is checked
  get selectedAll() {
    return this.selectAllTarget.checked
  }

  // Returns all selected checkboxes
  get selected() {
    return this.checkboxTargets.filter(target => target.checked)
  }

  // Returns all unselected checkboxes
  get unselected() {
    return this.checkboxTargets.filter(target => !target.checked)
  }

  // Returns data-id attributes for all selected checkboxes
  get selectedIds() {
    return this.selected.map(target => target.dataset.id)
  }

  // Returns true if all checkboxes are checked
  get allCheckboxesSelected() {
    return this.checkboxTargets.every(target => target.checked)
  }

  // Returns true if no checkboxes are checked
  get noCheckboxesSelected() {
    return this.checkboxTargets.every(target => !target.checked)
  }
}
