module Analytic
  class Vessel < ApplicationRecord
    self.table_name = "vessels"
    extend Enumerize
    include Uploader::VesselAttachmentUploader::Attachment(:genre_error_reporting)

    has_many :genres, class_name: Analytic::Genre.name, foreign_key: :imo, primary_key: :imo
    has_many :genre_sim_channels, class_name: Analytic::GenreSimChannel.name, through: :genres

    enumerize :genre_error_code, in: [:in_processing, :finished, :failed]

    has_many :focs, class_name: :Foc, foreign_key: :imo, primary_key: :imo

    scope :target, -> (target) { where(target: target) if target.present? }

  end
end
