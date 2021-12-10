module Analytic
  module ManagementServices
    module Importing
      class Foc < Base
        SPEED = "B"#{}"Speed [kt]."
        LADEN = "C"#{}"Laden FOC"
        BALLAST = "D"#{}"Ballast FOC"
        IMO = "A"#{}"Imo"

        def call
          focs = {}
          rows.each_with_index do |row, index|
            next if index == 0
            foc = Analytic::Foc.new({imo: row[IMO], speed: row[SPEED], laden: row[LADEN], ballast: row[BALLAST],
                                    temp_imo: row[IMO], temp_speed: row[SPEED], temp_laden: row[LADEN], temp_ballast: row[BALLAST],
                                    created_by_id: user_id, updated_by_id: user_id})
            focs["#{row[IMO].to_i}_#{row[SPEED]}"] = foc
          end

          results = Analytic::Foc.import(focs.values, on_duplicate_key_update: {conflict_target: [:imo, :speed], columns: [:laden, :ballast, :updated_by_id]})

          error_instances = results.failed_instances
          error_instances.each do |foc|
            error_rows << [foc.temp_imo, foc.temp_speed, foc.temp_laden, foc.temp_ballast, foc.errors.full_messages.join(",")]
          end

          Analytic::ManagementServices::Importing::ErrorFile.new(user_id, Analytic::ReportFile::FOC, error_rows).call
        end
      end
    end
  end
end
