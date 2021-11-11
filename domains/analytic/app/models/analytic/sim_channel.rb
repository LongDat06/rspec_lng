module Analytic
  class SimChannel
    include Mongoid::Document
    include Mongoid::Search
    include Mongoid::Timestamps::Created

    NOT_AVAILABLE_TYPE = 'N/A'

    NULL_UNITS = ["", "-", 'null', "None", "(None)", "N/A"]

    field :local_name, type: String
    field :standard_name, type: String
    field :iso_std_name, type: String
    field :unit, type: String
    field :imo_no, type: Integer
    field :genre, type: String

    index({ imo_no: 1, standard_name: 1 })
    search_in :local_name

    scope :unit, -> (unit) {
      return unless unit.present?
      unit = unit == "N/A" ? nil : unit
      where(unit: unit)
    }

    def self.fetch_units
      Rails.cache.fetch(:channel_units) do
        channels = self.collection.aggregate(
                                              [
                                                {
                                                   "$project" => {
                                                      "unit" => { "$ifNull" => [ "$unit", "N/A" ] }
                                                   }
                                                }
                                              ]
                                            )
        channels.map {|channel| channel["unit"]}.uniq
      end
    end

    def self.update_unit_to_na
      self.where(:unit.in => NULL_UNITS).update_all(unit: nil)
      Rails.cache.delete(:channel_units)
      self.fetch_units
    end
  end
end
