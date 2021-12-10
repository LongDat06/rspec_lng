module Analytic
  class Foc < ApplicationRecord
    validates_uniqueness_of :speed, scope: [:imo]
    validates_presence_of :speed, :imo, :laden, :ballast
    validates_length_of :imo, is: 7
    validates :speed, :laden, :ballast, numericality: { greater_than: 0 }
    validate :validate_imo

    belongs_to :updated_by, class_name: Shared::User.name, foreign_key: :updated_by_id
    attr_accessor :temp_imo, :temp_speed, :temp_laden, :temp_ballast

    def validate_imo
    	unless Analytic::Vessel.exists?(imo: self.imo, target: true)
    		errors.add(:imo, "should be existed in the target vessels")
    	end
    end
  end
end
