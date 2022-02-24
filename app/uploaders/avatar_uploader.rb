class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :aws # 本番環境
  else
    storage :file # 本番環境以外
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_limit: [150, 150]
  
  # In many cases, especially when working with images, it might be a good idea to provide a default url, a fallback in case no file has been uploaded. You can do this easily by overriding the default_url method in your uploader:
  def default_url
    'profile-placeholder.png'
  end

  if Rails.env.production?
    # 開発環境エラー対処
    def url
      "https://image.diaryapp.net/" + self.current_path
    end
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  def filename
    original_filename if original_filename
  end
  
end
