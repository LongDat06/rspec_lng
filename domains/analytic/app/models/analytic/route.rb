module Analytic
  class Route < ApplicationRecord
    validates :port_1, :port_2, :pacific_route, presence: true
    validates_uniqueness_of :pacific_route, scope: [:port_1, :port_2], case_sensitive: false
    validates :distance, numericality: { greater_than: 0 }
    belongs_to :updated_by, class_name: Shared::User.name, foreign_key: :updated_by
    before_validation :initialize_keys

    def self.fetch_first_ports(port = nil)
      query = <<-SQL
            SELECT port FROM (SELECT distinct(port_2) as port FROM analytic_routes
            WHERE :port IS NULL OR lower(port_2) LIKE CONCAT('%', :port, '%')
            UNION
            SELECT distinct(port_1) as port FROM analytic_routes
            WHERE :port IS NULL OR lower(port_1) LIKE CONCAT('%', :port, '%')) as ports
            ORDER BY lower(port)
            SQL
      self.find_by_sql(ActiveRecord::Base.send(:sanitize_sql_array,
                                               [query, port: port.to_s.downcase])).pluck(:port)
    end

    def self.fetch_second_ports(port_1)
      query = <<-SQL
            SELECT port FROM (SELECT distinct(port_2) as port FROM analytic_routes WHERE port_1 = :port_1
            UNION
            SELECT distinct(port_1) as port FROM analytic_routes WHERE port_2 = :port_1) as ports
            ORDER BY lower(port)
            SQL
      self.find_by_sql([query, {port_1: port_1}]).pluck(:port)
    end

    def self.fetch_routes(port_1, port_2)
      query = <<-SQL
            SELECT pacific_route FROM (SELECT distinct(pacific_route) FROM analytic_routes WHERE port_1 = :port_1 AND port_2 = :port_2
            UNION
            SELECT distinct(pacific_route) FROM analytic_routes WHERE port_2 = :port_1 AND port_1 = :port_2) as ports
            ORDER BY lower(pacific_route)
            SQL
      self.find_by_sql([query, {port_1: port_1, port_2: port_2}]).pluck(:pacific_route)
    end

    def self.find_route(port_1, port_2, pacific_route)
      port_1, port_2 = [port_1, port_2].sort
      where_conds = <<~SQL
        pacific_route = :pacific_route AND
        port_1 = :port_1 AND port_2 = :port_2
      SQL
      where(where_conds, { port_1: port_1,
                           port_2: port_2,
                           pacific_route: pacific_route }).first
    end

    private

    def initialize_keys
      self.pacific_route = self.pacific_route.upcase
      self.port_1, self.port_2 = [self.port_1.to_s.upcase, self.port_2.to_s.upcase].sort
    end
  end
end
