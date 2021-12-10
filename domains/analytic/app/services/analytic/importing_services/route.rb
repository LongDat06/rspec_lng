module Analytic
  module ImportingServices
    class Route
      PORT_1 = "Port 1"
      PORT_2 = "Port 2"
      NAME = "Route"
      DISTANCE = "Distance Nm"
      DETAIL = "Route datail"
      attr_accessor :file_name

      def initialize(file_name)
        @file_name = file_name
      end

      def call
        logger ||= Logger.new("#{Rails.root}/log/importing_routes.log")
        file_path = "#{Rails.root}/domains/analytic/data/#{file_name}"
        return if file_name.blank?
        return unless File.exist? file_path

        CSV.foreach(file_path, headers: true) do |row|
          begin
            port_1, port_2 = [row[PORT_1], row[PORT_2]].sort
            Analytic::Route.create!({port_1: port_1, port_2: port_2, pacific_route: row[NAME], distance: row[DISTANCE].to_i, detail: row[DETAIL]})
          rescue => error
            logger.info("---------error: #{error.inspect}  at row: #{row.inspect}-------------")
          end
        end
      end
    end
  end
end
