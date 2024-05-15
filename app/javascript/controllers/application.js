import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

import jQuery from "jquery"
window.jQuery = jQuery
window.$ = jQuery
