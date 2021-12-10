module Analytic
  class MasterPort < ApplicationRecord
    validates :name, uniqueness: true, presence: true
    validates :country_code, :time_zone, presence: true
    before_destroy :validate_destroy
    before_validation :force_upcase

    belongs_to :updated_by, class_name: Shared::User.name, foreign_key: :updated_by_id

    def validate_destroy
      if Analytic::Route.exists?(port_1_id: self.id) || Analytic::Route.exists?(port_2_id: self.id)
        raise I18n.t("analytic.used_message", name: "Port")
      end
    end

    def self.autocomplete_ports(port_param)
      ports = self.where("upper(name) like upper(?)", "%#{port_param}%")#.limit(20)
      ports.map {|port| {port.id => port.name} }
    end

    def self.sort_port(ports)
      first_port = self.find_by_name ports.first
      second_port = self.find_by_name ports.last
      [first_port&.id, second_port&.id]
    end

    private
    def force_upcase
      self.name = self.name.to_s.upcase
    end
  end
end
