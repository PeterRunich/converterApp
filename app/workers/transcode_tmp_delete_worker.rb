class TranscodeTmpDeleteWorker
  include Sidekiq::Worker

  def perform(output_path)
    File.delete output_path if File.exist? output_path
  end
end
