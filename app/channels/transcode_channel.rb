class TranscodeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "transcode_#{params[:transcode_id]}"
  end
end
