module Analytic
  class SimChannel
    include Mongoid::Document
    include Mongoid::Search
    include Mongoid::Timestamps::Created

    field :local_name, type: String
    field :standard_name, type: String
    field :iso_std_name, type: String
    field :unit, type: String
    field :imo_no, type: Integer

    index({ imo_no: 1, standard_name: 1 })
    search_in :local_name

    scope :unit, -> (unit) {
      return unless unit.present?
      return where(:unit.in => ["", nil])  if unit == 'none'
      where(unit: /.*#{unit}.*/i)
    }

    def self.fetch_units
      Rails.cache.fetch(:channel_units) do
        self.distinct("unit")
      end
    end
  end
end
