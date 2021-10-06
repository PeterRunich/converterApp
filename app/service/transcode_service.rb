class TranscodeService

  def initialize(media, transcode_id)
    @media = media
    @transcode_id = transcode_id
  end

  def perform
    FileUtils.cp @media.path, file_path

    TranscodeWorker.perform_async file_path, @transcode_id
    TranscodeTmpDeleteWorker.perform_at 1.minute.from_now, output_path
  end

  def transcode(&block)
    FFMPEG::Movie.new(file_path).tap do |file|
      file.transcode(output_path, %w[-r 10 -loop 0], &block)
    end
  end

  private

  def file_path
    "/tmp/#{@transcode_id}#{File.extname(@media)}"
  end

  def output_path
    "/tmp/transcoded-#{@transcode_id}.gif"
  end
end
