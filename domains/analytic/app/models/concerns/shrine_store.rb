module ShrineStore
  def upload_temporary_file(local_path)
    uploader = Analytic::Uploader::TemporaryUploader.new(:cache)
    uploader = uploader.upload(File.open(local_path))
    uploader.url
  end
end
