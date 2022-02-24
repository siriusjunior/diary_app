class DiaryImageUploader < CarrierWave::Uploader::Base
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

  if Rails.env.production?
    # 開発環境エラー対処
    def url
      "https://image.diaryapp.net/" + self.current_path
    end
  end

  process resize_to_limit: [700, 700]

  def extension_allowlist
    %w[jpg jpeg gif png]
  end

  # You can find a full list of custom headers in AWS SDK documentation on
  # AWS::S3::S3Object
  # def download_url(filename)
  #   url(response_content_disposition: %Q{attachment; filename="#{filename}"})
  # end
  def filename
    original_filename if original_filename
  end
  
end
