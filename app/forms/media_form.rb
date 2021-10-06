class MediaForm
  include ActiveModel::Model

  attr_accessor :file_path

  validates :file_path, presence: { message: 'должно присутствовать' }
  validate :correct_media_type, :duration_of_media, unless: :file_path?

  private

  def correct_media_type
    unless %w[.flv .mpeg .ogm .mpg .wmv .webm .ogv .mov .m4v .asx .mp4 .avi].include? File.extname file_path
      errors.add(:base, 'Поддерживаемые форматы .flv .mpeg .ogm .mpg .wmv .webm .ogv .mov .m4v .asx .mp4 .avi.')
    end
  end

  def duration_of_media
    if FFMPEG::Movie.new(file_path).duration > 60
      errors.add(:base, 'Продолжительность видео должно быть меньше минуты.')
    end
  end

  def file_path?
    file_path.blank?
  end
end