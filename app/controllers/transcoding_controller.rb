class TranscodingController < ApplicationController
  def new; end

  def create
    file_path = params[:media] ? params[:media].path : nil

    MediaForm.new(file: file_path, transcode_id: params[:transcode_id]).tap do |media|
      if media.valid?
        TranscodeService.new(params[:media], params[:transcode_id]).perform
        head :ok
      else
        render json: { error: media.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def show
    file_path = "/tmp/transcoded-#{params[:id]}.gif"

    return head :not_found unless File.exist? file_path

    send_data File.read(file_path), filename: File.basename(file_path), type: 'image/gif'

    File.delete file_path
  end
end
