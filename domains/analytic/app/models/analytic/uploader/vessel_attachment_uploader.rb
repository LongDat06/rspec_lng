module Analytic
  module Uploader
    class VesselAttachmentUploader < Shrine
      plugin :activerecord
      plugin :pretty_location, namespace: '/', identifier: :imo
      plugin :remove_attachment
      plugin :upload_options, store: { acl: "private" }
      plugin :url_options,    store: { public: false }
    end
  end
end
