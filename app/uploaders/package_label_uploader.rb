class PackageLabelUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "package/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "label.#{file.extension}" if original_filename
  end
end
