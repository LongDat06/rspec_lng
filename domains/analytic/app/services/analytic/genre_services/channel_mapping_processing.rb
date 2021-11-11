module Analytic
  module GenreServices
    class ImportProcessingError < StandardError; end
    class ChannelMappingProcessing
      include Wisper::Publisher

      def initialize(imo:, job_id: nil)
        @imo = imo
        @job_id = job_id
      end

      def call
        mapping_processing
      end

      private
        attr_reader :missing_stdnames, :imo, :job_id, :genre_set

        def mapping_processing
          @missing_stdnames = []
          @genre_set = Set.new
          bulk_commands = []
          sim_channels.each do |channel|
            genre = nil
            if channel_genre_mapping.key? channel.iso_std_name
              genre = channel_genre_mapping[channel.iso_std_name]
            else
              @missing_stdnames << [channel.iso_std_name]
            end
            bulk_commands << {
              update_one: { filter: { _id: channel.id }, update: { '$set' => { genre: genre }}}
            }
            @genre_set << (genre.presence || Analytic::Genre::NOT_AVAILABLE_TYPE)
          end
          Analytic::SimChannel.collection.bulk_write(bulk_commands) if bulk_commands.present?
          Analytic::Genre.where(imo: imo, name: genre_set.to_a).update_all(active: true) if genre_set.present?
          report_job
        rescue => e
          broadcast(:on_failed_error_report, { imo: imo, errors: [e.message], job_id: job_id })
          raise ImportProcessingError, e
        end

        def sim_channels
          @sim_channels ||= Analytic::SimChannel.only(:id, :iso_std_name, :genre)
                                                .where(imo_no: imo)
        end

        def unknown_stdnames
          @unknown_stdnames ||= begin
            differences = channel_genre_mapping.keys - sim_channels.map(&:iso_std_name)
            channel_genre_mapping.slice(*differences).to_a
          end
        end

        def report_job
          if unknown_stdnames.empty? && missing_stdnames.empty?
            broadcast(:on_genre_import_finshed, { imo: imo,
                                                  job_id: job_id })
          else
            broadcast(:on_notfound_genre_mapping_report, { imo: imo,
                                                           missing_stdnames: missing_stdnames,
                                                           unknown_stdnames: unknown_stdnames,
                                                           job_id: job_id })
          end
        end

        def channel_genre_mapping
          @channel_genre_mapping ||= begin
            genre_channels = vessel.genre_sim_channels.includes(:genre).order(:id)
            genre_channels.find_each.reduce({}) do |mapped, channel|
              mapped[channel.iso_std_name] = channel.genre.name
              mapped
            end
          end
        end

        def vessel
          @vessel ||= Analytic::Vessel.find_by(imo: imo)
        end

    end
  end
end
