module Analytic
  class DownloadCondition
    include Mongoid::Document

    field :columns, type: Hash
    field :timestamp_from_at, type: DateTime
    field :timestamp_to_at, type: DateTime

    embedded_in :download
  end
end
