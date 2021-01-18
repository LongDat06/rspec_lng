require "shrine"
require "shrine/storage/s3"

s3_options = {
  bucket:            ENV['AWS_S3_BUCKET'], # required
  region:            ENV['AWS_REGION'], # required
  access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "lng_uploads/cache", **s3_options),
  store: Shrine::Storage::S3.new(public: true, prefix: "lng_uploads", **s3_options)
}

Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files
