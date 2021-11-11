module Analytic
  class GenreChannelMappingListener

    def on_proccessing_genre_import(imo)
      update_vessel_genre_error_code(imo, :in_processing)
    end

    def on_genre_import_finshed(params)
      imo = params.fetch(:imo)
      job_id = params[:job_id]
      update_vessel_genre_error_code(imo, :finished)
      broadcast_websocket(job_id, :finished) if job_id.present?
    end

    def on_notfound_genre_mapping_report(params)
      imo = params.fetch(:imo)
      missing_stdnames = params.fetch(:missing_stdnames)
      unknown_stdnames = params.fetch(:unknown_stdnames)
      job_id = params[:job_id]
      Analytic::GenreServices::Exporting::GenreChannelNotFoundErrorReportXlsx.new(imo: imo,
                                                                                  unknown_stdnames: unknown_stdnames,
                                                                                  missing_stdnames: missing_stdnames).()
      update_vessel_genre_error_code(imo, :failed)
      broadcast_websocket(job_id, :failed) if job_id.present?
    end

    def on_failed_error_report(params)
      imo = params.fetch(:imo)
      errors = params.fetch(:errors)
      job_id = params[:job_id]
      Analytic::GenreServices::Exporting::GenreChannelErrorReportCsv.new(imo: imo, errors: errors).()
      update_vessel_genre_error_code(imo, :failed)
      broadcast_websocket(job_id, :failed)
    end

    private
    def update_vessel_genre_error_code(imo, error_code)
      vessel = Analytic::Vessel.find_by(imo: imo)
      vessel.genre_error_code = error_code
      vessel.save(validate: false)
    end

    def broadcast_websocket(job_id, status)
      ActionCable.server.broadcast("importing_job_for_#{job_id}", status)
    end

  end
end
