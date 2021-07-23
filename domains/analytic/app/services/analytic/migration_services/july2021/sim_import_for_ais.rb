module Analytic
  module MigrationServices
    module July2021
      class SimImportForAis
        BATCH_IMPORT_SIZE = 10

        def initialize(imo_no:,column_mapping:, sim_file_path:, current_time: Time.current)
          @imo_no = imo_no
          @column_mapping = column_mapping
          @current_time = current_time
          @sim_file_path = sim_file_path
          @records = []
          @counter = 0
        end

        def call
          processing_rows
        end

        private
        attr_reader :records
        attr_accessor :counter

        def processing_rows
          CSV.foreach(@sim_file_path, headers: false) do |row|
            increment_counter
            records << modeling_record(row, 1)
          end
          ais = []
          vessel_destinations = []
          records.each do |record|
            next if latitude_attrs(record[:spec]).blank? || longitude_attrs(record[:spec]).blank?
            ais << {
              imo: @imo_no,
              latitude: latitude_attrs(record[:spec]),
              longitude: longitude_attrs(record[:spec]),
              speed_over_ground: record[:spec][:'jsmea_nav_gnss_sog'].present? ? record[:spec][:'jsmea_nav_gnss_sog'].to_f : nil,
              heading: record[:spec][:'jsmea_nav_compass_heading_direction'].present? ? record[:spec][:'jsmea_nav_compass_heading_direction'].to_f : nil,
              is_valid: true,
              source: :sim,
              last_ais_updated_at: record[:spec][:'ts']
            }

            vessel_destinations << {
              imo: @imo_no,
              draught: draught(record[:spec], @imo_no),
              last_ais_updated_at: record[:spec][:'ts']
            }
          end
          Ais::Tracking.import!([:imo, :latitude, :longitude, :speed_over_ground, :heading, :is_valid, :last_ais_updated_at], ais)
          Ais::VesselDestination.import!([:imo, :draught, :last_ais_updated_at], vessel_destinations.reject {|item| item[:draught].blank? })
        end

        def draught(attributes, imo)
          if imo == 9779226
            return if attributes[:'jsmea_mac_lbl00001p'].blank? || attributes[:'jsmea_mac_lbl00001s'].blank?
            (attributes[:'jsmea_mac_lbl00001p'].to_f + attributes[:'jsmea_mac_lbl00001s'].to_f) / 2
          elsif imo == 9810020
            return if attributes[:'jsmea_mac_a0545'].blank? || attributes[:'jsmea_mac_a0546'].blank?
            (attributes[:'jsmea_mac_a0545'].to_f + attributes[:'jsmea_mac_a0546'].to_f) / 2
          else
            return if attributes[:'jsmea_mac_bas014-lia'].blank? || attributes[:'jsmea_mac_bas015-lia'].blank?
            (attributes[:'jsmea_mac_bas014-lia'].to_f + attributes[:'jsmea_mac_bas015-lia'].to_f) / 2
          end
        end

        def longitude_attrs(attributes)
          return if attributes[:'jsmea_nav_gnss_start_ccrp_lon'].blank? || attributes[:'jsmea_nav_gnss_start_ccrp_lon_ew'].blank?
          convert_lat_lon(attributes[:'jsmea_nav_gnss_start_ccrp_lon'], attributes[:'jsmea_nav_gnss_start_ccrp_lon_ew']) 
        end

        def latitude_attrs(attributes)
          return if attributes[:'jsmea_nav_gnss_start_ccrp_lat'].blank? || attributes[:'jsmea_nav_gnss_start_ccrp_lat_ns'].blank?
          convert_lat_lon(attributes[:'jsmea_nav_gnss_start_ccrp_lat'], attributes[:'jsmea_nav_gnss_start_ccrp_lat_ns'])
        end

        def convert_lat_lon(position, direction)
          if check_digit(position) == 1 || check_digit(position) == 2
            dd = 0 + position.to_f / 60
          elsif check_digit(position) == 3
            
            dd = position[0..0].to_i + position[1..-1].to_f / 60
          elsif check_digit(position) == 4
            
            dd = position[0..1].to_i + position[2..-1].to_f / 60
          elsif check_digit(position) == 5
            
            dd = position[0..2].to_i + position[3..-1].to_f / 60
          end

          if (direction == "S" || direction == "W")
            dd = dd * -1
          end
          
          dd
        end

        def check_digit(number)
          Math.log10(number.to_f).to_i + 1
        end

        def increment_counter
          self.counter += 1
        end

        def modeling_sim_spec(row, index)
          {}.tap do |hashing|
            @column_mapping.each do |column_name, column_mapped|
              next if row.blank?
              row_data = row[column_mapped[:index]]
              if [
                  :ts,
                  :jsmea_nav_gnss_start_ccrp_lon,
                  :jsmea_nav_gnss_start_ccrp_lon_ew,
                  :jsmea_nav_gnss_start_ccrp_lat,
                  :jsmea_nav_gnss_start_ccrp_lat_ns,
                  :jsmea_nav_gnss_sog,
                  :jsmea_nav_compass_heading_direction,
                  :"jsmea_mac_bas014-lia",
                  :"jsmea_mac_bas015-lia",
                  :"jsmea_mac_lbl00001p",
                  :"jsmea_mac_lbl00001s",
                  :"jsmea_mac_a0545",
                  :"jsmea_mac_a0546",
                ].include?(column_name)
                hashing[column_name] = row_data
              end
            end
          end
        end

        def modeling_record(row, index)
          {
            imo_no: @imo_no,
            spec: modeling_sim_spec(row, index)
          }
        end

        def numeric?(data_type)
          data_type == 'numeric'
        end

        def datetime?(data_type)
          data_type == 'datetime'
        end

        def rows
          @rows ||= sim_data_sheet.sheets.first.rows
        end

        def sim_data_sheet
          @sim_data_sheet ||= Creek::Book.new(@sim_file_path)
        end

        def reached_batch_import_size?
          (counter % BATCH_IMPORT_SIZE).zero?
        end

        def row_count
          @row_count ||= rows.count
        end

        def reached_end_of_file?
          counter == row_count
        end
      end
    end
  end
end