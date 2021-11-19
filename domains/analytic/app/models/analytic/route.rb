module Analytic
  class Route < ApplicationRecord
    validates_uniqueness_of :pacific_route, scope: [:port_1, :port_2]
    validate :different_distance

    def self.fetch_first_ports
      query = <<-SQL
            SELECT port FROM (SELECT distinct(port_2) as port FROM analytic_routes
            UNION
            SELECT distinct(port_1) as port FROM analytic_routes) as ports
            ORDER BY lower(port)
            SQL
      self.find_by_sql(query).pluck(:port)
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

    private
    def different_distance
      if self.class.exists?(port_1: self.port_2, port_2: self.port_1, pacific_route: self.pacific_route)
        errors.add(:distance, "should be the same with existing route")
      end
    end
  end
end
