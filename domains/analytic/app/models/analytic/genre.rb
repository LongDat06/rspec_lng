module Analytic
  class Genre < ApplicationRecord

    OTHER_NAME = 'Other'
    NOT_AVAILABLE_TYPE = 'N/A'

    belongs_to :vessels, class_name: Vessel.name, foreign_key: :imo, primary_key: :imo
    has_many :genre_sim_channels, class_name: GenreSimChannel.name,
                                  foreign_key: :analytic_genres_id,
                                  inverse_of: :genre,
                                  dependent: :delete_all

    validates_presence_of :imo, :name
    validates_uniqueness_of :name, scope: :imo

    scope :active, -> { where(active: true) }

  end
end
