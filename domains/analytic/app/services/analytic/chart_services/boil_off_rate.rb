module Analytic
  module ChartServices
    class BoilOffRate
      BUILDING_MODEL = Struct.new(
        :id, 
        :created_at, 
        :jsmea_mac_cargotk_bor_include_fv, 
        :jsmea_mac_cargotk_bor_exclude_fv,
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
                { "jsmea_mac_cargotk_bor_include_fv" => { "$exists" => true }}, 
                { "jsmea_mac_cargotk_bor_exclude_fv" => { "$exists" => true }}
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
                  jsmea_mac_cargotk_bor_include_fv: "$jsmea_mac_cargotk_bor_include_fv",
                  jsmea_mac_cargotk_bor_exclude_fv: "$jsmea_mac_cargotk_bor_exclude_fv" 
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
