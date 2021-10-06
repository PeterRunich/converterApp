import { Controller } from "@hotwired/stimulus"
import { v4 as uuid } from 'uuid';
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["input", "output", "progressBar"]

  uploaded() {
    this.transcode_id = uuid()
    this.websocketInit()
    this.sendMedia()
  }

  websocketInit() {
    this.channel = consumer.subscriptions.create({ channel: "TranscodeChannel", transcode_id: this.transcode_id },
                                                 { received: this.received.bind(this) })
  }

  sendMedia() {
    const formData = new FormData()

    formData.append('media', this.inputTarget.files[0])
    formData.append('transcode_id', this.transcode_id)

    fetch('/transcoding', {
      headers: { "X-CSRF-Token" : document.getElementsByName("csrf-token")[0].content },
      method: 'POST',
      body: formData
    }).then(res => this.sendMediaResponse(res))

    this.inputTarget.value = null
  }

  received(data) {
    data["args"] ||= []

    this[data["method"]](...data["args"])
  }

  setProgress(progress) {
    this.progressBarTarget.style.width = `${progress * 100}%`
  }

  ready() {
    this.outputTarget.src = `/transcoding/${this.transcode_id}`
    this.outputTarget.classList.remove('hidden')

    setTimeout(()=>this.channel.consumer.disconnect(), 1000)
  }

  async sendMediaResponse(res) {
    if (res.ok) return;
    let errors = await res.json()

    alert(errors["error"])
  }
}
