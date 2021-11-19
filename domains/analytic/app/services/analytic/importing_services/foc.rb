module Analytic
  module ImportingServices
    class Foc
      SPEED = "Speed [kt]."
      LADEN = "Laden FOC"
      BALLAST = "Ballast FOC"
      IMO = "Imo"

      attr_accessor :file_name

      def initialize(file_name)
        @file_name = file_name
      end

      def call
        logger ||= Logger.new("#{Rails.root}/log/importing_foc.log")
        file_path = "#{Rails.root}/domains/analytic/data/#{file_name}"
        return if file_name.blank?
        return unless File.exist? file_path

        CSV.foreach(file_path, headers: true) do |row|
          begin
            Analytic::Foc.create!({imo: row[IMO], speed: row[SPEED], laden: row[LADEN], ballast: row[BALLAST]})
          rescue => error
            logger.info("---------error: #{error.inspect}  at row: #{row.inspect}-------------")
          end
        end
      end
    end
  end
end
