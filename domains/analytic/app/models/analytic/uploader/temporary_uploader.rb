module Analytic
  module Uploader
    class TemporaryUploader < Shrine
      plugin :upload_endpoint
      plugin :default_storage, store: :cache
      plugin :upload_options, store: { acl: "private" }
      plugin :url_options,    store: { public: false }
    end
  end
end
