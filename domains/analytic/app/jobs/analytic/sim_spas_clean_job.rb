module Analytic
  class SimSpasCleanJob < ApplicationJob
    queue_as :cleaning_job

    def perform
      Analytic::CleanServices::SimData.new.()    
      Analytic::CleanServices::SpasData.new.()    
    end
  end
end
