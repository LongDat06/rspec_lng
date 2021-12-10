module Analytic
  module ManagementServices
    module Importing
      class Foc < Base
        SPEED = "B"#{}"Speed [kt]."
        LADEN = "C"#{}"Laden FOC"
        BALLAST = "D"#{}"Ballast FOC"
        IMO = "A"#{}"Imo"

        def call
          user = Shared::User.find user_id
          focs = {}
          rows.each_with_index do |row, index|
            next if index == 0
            foc = Analytic::Foc.new({imo: row[IMO].to_i, speed: row[SPEED].to_f, laden: row[LADEN].to_f, ballast: row[BALLAST].to_f, created_by: user, updated_by: user})
            focs["#{row[IMO].to_i}_#{row[SPEED]}"] = foc
          end
          results = Analytic::Foc.import(focs.values, on_duplicate_key_update: {conflict_target: [:imo, :speed], columns: [:laden, :ballast, :updated_by]})

          error_instances = results.failed_instances
          error_instances.each do |foc|
            error_rows << [foc.imo, foc.speed, foc.laden, foc.ballast, foc.errors.full_messages.join(",")]
          end

          Analytic::ManagementServices::Importing::ErrorFile.new(user_id, Analytic::ReportFile::FOC, error_rows).call
        end
      end
    end
  end
end
