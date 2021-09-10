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
      where(unit: unit)
    }

    def self.fetch_units
      Rails.cache.fetch(:channel_units) do
        self.distinct("unit")
      end
    end

    def self.update_unit_to_na
      self.where(:unit.in => ["", "-", nil]).update_all(unit: "N/A")
      Rails.cache.delete(:channel_units)
      self.fetch_units
    end
  end
end
