module Analytic
  class Route < ApplicationRecord
    validates :master_route_id, :distance, presence: true
    validates_uniqueness_of :master_route_id, scope: [:port_1_id, :port_2_id], case_sensitive: false
    validates :distance, numericality: { greater_than: 0 }
    belongs_to :updated_by, class_name: Shared::User.name, foreign_key: :updated_by_id
    belongs_to :master_route, class_name: MasterRoute.name, foreign_key: :master_route_id, required: false

    before_destroy :validate_destroy
    before_validation :initialize_keys
    validate :validate_dup_port

    attr_accessor :temp_route_name, :temp_port_name_1, :temp_port_name_2, :temp_distance

    def self.fetch_first_ports(port = nil)
      query = <<-SQL
            SELECT distinct(name), master_ports.id FROM analytic_master_ports master_ports
            JOIN analytic_routes ON (port_1_id = master_ports.id OR port_2_id = master_ports.id)
            ORDER BY name
            SQL
      self.find_by_sql(ActiveRecord::Base.send(:sanitize_sql_array,
                                               [query, port: port])).map {|route| {route.id => route.name}}
    end

    def self.fetch_second_ports(port_1)
        query = <<-SQL
            SELECT name, port_id FROM (SELECT distinct(mp.name) as name,  analytic_routes.port_2_id as port_id FROM analytic_routes
                                       JOIN analytic_master_ports mp ON analytic_routes.port_2_id = mp.id
                                       WHERE analytic_routes.port_1_id = :port_1
                                      UNION
                                      SELECT distinct(mp.name) as name,  analytic_routes.port_1_id as port_id FROM analytic_routes
                                      JOIN analytic_master_ports mp ON analytic_routes.port_1_id = mp.id
                                      WHERE analytic_routes.port_2_id = :port_1) as ports
            ORDER BY name
            SQL
        self.find_by_sql([query, {port_1: port_1.to_i}]).map {|route| {route.port_id => route.name}}
    end


    def self.fetch_routes(port_1, port_2)
      query = <<-SQL
            SELECT distinct(name), master_routes.id FROM analytic_master_routes master_routes
            JOIN  analytic_routes ON analytic_routes.master_route_id = master_routes.id
            WHERE ((:port_1 IS NULL AND :port_2 IS NULL) OR
                  (port_1_id = :port_1 AND port_2_id = :port_2) OR (port_1_id = :port_2 AND port_2_id = :port_1))
            ORDER BY name
            SQL

      self.find_by_sql(ActiveRecord::Base.send(:sanitize_sql_array, [query, {port_1: port_1, port_2: port_2}])).map {|route| {route.id => route.name}}
    end

    def self.find_route(port_1, port_2, master_route_id)
      where_conds = <<~SQL
        master_route_id = :master_route_id AND
        ((port_1_id = :port_1 AND port_2_id = :port_2) OR
        (port_1_id = :port_2 AND port_2_id = :port_1))
      SQL
      where(where_conds, { port_1: port_1,
                           port_2: port_2,
                           master_route_id: master_route_id }).first
    end

    private

    def validate_destroy
      where_conds = <<~SQL
        master_route_id = :master_route_id AND
        ((port_dept_id = :port_1 AND port_arrival_id = :port_2) OR
        (port_dept_id = :port_2 AND port_arrival_id = :port_1))
      SQL
      heel_result = Analytic::HeelResult.where(where_conds, { port_1: self.port_1_id,
                           port_2: self.port_2_id,
                           master_route_id: self.master_route_id }).first
      if heel_result.present?
        raise I18n.t("analytic.used_message", name: "Distance Route")
      end
    end

    def initialize_keys
      return unless self.new_record?
      return if self.temp_route_name.blank?
      self.temp_route_name = self.temp_route_name.to_s.upcase
      route_id = Analytic::MasterRoute.find_or_create_by(name: self.temp_route_name)&.id unless self.errors.any?
      self.master_route_id = route_id
    end

    def validate_dup_port
      return unless self.new_record?
      if port_1_id.present? && port_2_id.present? && port_1_id == port_2_id
        errors.add(:base, "Port Name 1 and Port Name 2 should not be duplicated.")
      end

      if !port_1_id.present? && self.temp_port_name_1.present?
        errors.add(:port_1_id, "must exist in Master Port List")
      end
      unless self.temp_port_name_1.present?
        errors.add(:port_1_id, "can't be blank")
      end

      if !port_2_id.present? && self.temp_port_name_2.present?
        errors.add(:port_2_id, "must exist in Master Port List")
      end
      unless self.temp_port_name_2.present?
        errors.add(:port_2_id, "can't be blank")
      end
    end
  end
end
