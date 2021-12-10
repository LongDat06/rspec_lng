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
          routes = {}
          rows.each_with_index do |row, index|
            next if index == 0
            ports = [row[PORT_1].to_s.upcase, row[PORT_2].to_s.upcase].sort
            port_name_1 = ports.first
            port_name_2 = ports.last
            port_1_id, port_2_id = Analytic::MasterPort.sort_port(ports)
            route = Analytic::Route.new({port_1_id: port_1_id, port_2_id: port_2_id, temp_route_name: row[NAME],
                                        temp_port_name_1: port_name_1, temp_port_name_2: port_name_2, distance: row[DISTANCE],
                                        temp_distance: row[DISTANCE], detail: row[DETAIL], created_by_id: user_id, updated_by_id: user_id})
            routes["#{port_name_1}_#{port_name_2}_#{row[NAME].to_s.upcase}"] = route
          end
          results = Analytic::Route.import(routes.values, on_duplicate_key_update: {conflict_target: [:port_1_id, :port_2_id, :master_route_id],
                                                                             columns: [:distance, :detail, :updated_by_id]})
          error_instances = results.failed_instances
          error_instances.each do |route|
            error_rows << [ route.temp_port_name_1, route.temp_port_name_2, route.temp_route_name,
                          route.temp_distance, route.detail, route.errors.full_messages.join(",") ]
          end

          Analytic::ManagementServices::Importing::ErrorFile.new(user_id, Analytic::ReportFile::ROUTE, error_rows).call
        end
      end
    end
  end
end
