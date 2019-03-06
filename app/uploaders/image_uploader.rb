class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  
  if Rails.env.production?
  storage :fog
  else
  storage :file
  end

  # Directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end
  # stores all pics in project folder
  def store_dir
    "uploads/#{model.project_id.to_s}"
  end
  
  process :store_exif_lat_long
  
  def store_exif_lat_long 
    i = MiniMagick::Image.new(file.path)
    
    lat_raw = i.exif["GPSLatitude"]
    lat_parts = lat_raw.to_s.split(/[,\/]/)
    lat_parts = lat_parts.map {|x| x.to_f}
    lat_decimal = (lat_parts[0] / lat_parts[1]) + (lat_parts[2] / lat_parts[3] / 60.0) + (lat_parts[4] / lat_parts[5] / 3600.0)
    lat_decimal = (lat_decimal*1000000000).round / 1000000000
    
    long_raw = i.exif["GPSLongitude"] 
    long_parts = long_raw.to_s.split(/[,\/]/)
    long_parts = long_parts.map {|x| x.to_f}
    long_decimal = (long_parts[0] / long_parts[1]) + (long_parts[2] / long_parts[3] / 60.0) + (long_parts[4] / long_parts[5] / 3600.0)
    
    model.exif = i.exif 
    model.lat = lat_decimal
    model.long = long_decimal
  end
  
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
