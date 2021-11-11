module Analytic
  class GenreSimChannel < ApplicationRecord

    belongs_to :genre, class_name: Genre.name, foreign_key: :analytic_genres_id

    validates_presence_of :genre, :iso_std_name
    validates_uniqueness_of :iso_std_name, scope: :genre


  end
end
