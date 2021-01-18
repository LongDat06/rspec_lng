module Analytic
  module Uploader
    class AttachmentUploader < Shrine
      plugin :pretty_location, namespace: '/'
      plugin :mongoid
    end
  end
end
