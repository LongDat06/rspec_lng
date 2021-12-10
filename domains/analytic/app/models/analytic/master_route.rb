module Analytic
  class MasterRoute < ApplicationRecord
    validates :name, uniqueness: true, presence: true
    before_destroy :validate_destroy
    before_validation :force_upcase

    def validate_destroy
      if Analytic::Route.exists?(master_route_id: self.id)
        raise I18n.t("analytic.used_message", name: "Route")
      end
    end

    def self.autocomplete_routes(route_param)
      ports = self.where("upper(name) like upper(?)", "%#{route_param}%")
      ports.pluck :name
    end

    private
    def force_upcase
      self.name = self.name.to_s.upcase
    end
  end
end
