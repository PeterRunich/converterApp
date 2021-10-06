class MediaForm
  include ActiveModel::Model

  attr_accessor :file, :transcode_id

  validates :file, presence: { message: 'должен присутствовать' }
  validates :transcode_id, presence: { message: 'должен присутствовать' }
  validate  :correct_media_type, :duration_of_media, unless: :file?

  private

  def correct_media_type
    unless %w[.flv .mpeg .ogm .mpg .wmv .webm .ogv .mov .m4v .asx .mp4 .avi].include? File.extname file
      errors.add(:base, 'Поддерживаемые форматы .flv .mpeg .ogm .mpg .wmv .webm .ogv .mov .m4v .asx .mp4 .avi.')
    end
  end

  def duration_of_media
    errors.add(:base, 'Продолжительность видео должно быть меньше минуты.') if FFMPEG::Movie.new(file).duration > 60
  end

  def file?
    file.blank?
  end
end