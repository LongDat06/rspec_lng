module Analytic
  module ManagementServices
    module Importing
      class Route < Base
        PORT_1 = "A" #{}"Port 1"
        PORT_2 = "B"#{}"Port 2"
        NAME = "C"#{}"Route"
        DISTANCE = "D"#{}"Distance Nm"
        DETAIL = "E"#{}"Route datail"

        def call
          user = Shared::User.find user_id
          routes = {}
          rows.each_with_index do |row, index|
            next if index == 0
            route = Analytic::Route.new({port_1: row[PORT_1], port_2: row[PORT_2], pacific_route: row[NAME], distance: row[DISTANCE].to_i,
                                         detail: row[DETAIL], created_by: user, updated_by: user})
            routes["#{row[PORT_1].to_s.upcase}_#{row[PORT_2].to_s.upcase}_#{row[NAME].to_s.upcase}"] = route
          end
          results = Analytic::Route.import(routes.values, on_duplicate_key_update: {conflict_target: [:port_1, :port_2, :pacific_route],
                                                                             columns: [:distance, :updated_by]})
          error_instances = results.failed_instances
          error_instances.each do |route|
            error_rows << [route.port_1, route.port_2, route.pacific_route, route.distance, route.detail, route.errors.full_messages.join(",")]
          end
          Analytic::ManagementServices::Importing::ErrorFile.new(user_id, Analytic::ReportFile::ROUTE, error_rows).call
        end
      end
    end
  end
end
