module Analytic
  module ChartServices
    class TankEquator
      BUILDING_MODEL = Struct.new(
        :id, 
        :created_at, 
        :jsmea_mac_cargotk1_equator_temp,
        :jsmea_mac_cargotk2_equator_temp,
        :jsmea_mac_cargotk3_equator_temp,
        :jsmea_mac_cargotk4_equator_temp, 
        keyword_init: true
      )

      def initialize(from_time, to_time, imo)
        @from_time = from_time
        @to_time = to_time
        @imo = imo
      end

      def call
        Analytic::Sim.collection.aggregate([
          {
            "$match" => {
              "sim_metadata_id" => { "$in" => sim_meta_ids  }, 
              "$or" => [
                { "jsmea_mac_cargotk1_equator_temp" => { "$exists" => true }}, 
                { "jsmea_mac_cargotk2_equator_temp" => { "$exists" => true }},
                { "jsmea_mac_cargotk3_equator_temp" => { "$exists" => true }},
                { "jsmea_mac_cargotk4_equator_temp" => { "$exists" => true }}
              ]
            }
          },
          {
            "$group" => {
              "_id" => "$sim_metadata_id",
              "result" => { 
                "$mergeObjects" => {
                  id: "$sim_metadata_id",
                  created_at: "$created_at",
                  jsmea_mac_cargotk1_equator_temp: "$jsmea_mac_cargotk1_equator_temp",
                  jsmea_mac_cargotk2_equator_temp: "$jsmea_mac_cargotk2_equator_temp",
                  jsmea_mac_cargotk3_equator_temp: "$jsmea_mac_cargotk3_equator_temp",
                  jsmea_mac_cargotk4_equator_temp: "$jsmea_mac_cargotk4_equator_temp"
                } 
              }
            }
          }
        ]).map do |row|
          BUILDING_MODEL.new(row['result'])
        end
      end

      private
      def sim_meta_ids
        @sim_meta_ids ||= begin
          Analytic::SimMetadata
            .where(:created_at.gte => @from_time, :created_at.lte => @to_time)
            .where(imo_no: @imo.to_i)
            .pluck(:_id)
        end
      end
    end
  end
end
