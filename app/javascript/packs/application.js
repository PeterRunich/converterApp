import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import { Application } from "@hotwired/stimulus"
import "../controllers/index"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
Application.start()