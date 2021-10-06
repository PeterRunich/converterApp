class TranscodeWorker
  include Sidekiq::Worker

  def perform(file_path, transcode_id)
    TranscodeService.new(file_path, transcode_id).transcode do |progress|
      broadcast(transcode_id, method: :setProgress, args: [progress])
    end

    broadcast(transcode_id, method: :ready)

    File.delete file_path
  end

  private

  def broadcast(transcode_id, msg)
    ActionCable.server.broadcast("transcode_#{transcode_id}", msg)
  end
end
