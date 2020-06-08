# frozen_string_literal: true

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fill: [300, 300]

  version :thumb do
    process resize_to_fit: [30, 30]
  end

  def extension_white_list
    %w[jpg jpeg gif png]
  end
end
