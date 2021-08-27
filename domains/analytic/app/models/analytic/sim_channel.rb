module Analytic
  class SimChannel
    include Mongoid::Document
    include Mongoid::Search
    include Mongoid::Timestamps::Created

    field :local_name, type: String
    field :standard_name, type: String
    field :unit, type: String
    field :imo_no, type: Integer

    index(imo_no: 1)
    search_in :local_name

    def self.fetch_units
      Rails.cache.fetch(:channel_units) do
        self.distinct("unit")
      end
    end
  end
end
