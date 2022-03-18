module Analytic
  module V1
    module Edqs
      class ResultSerializer
        include FastJsonapi::ObjectSerializer

        attributes :imo,
                   :vessel_name,
                   :name,
                   :foe,
                   :init_lng_volume,
                   :laden_voyage_no,
                   :ballast_voyage_no,
                   :unpumpable,
                   :cosuming_lng_of_laden_voyage,
                   :cosuming_lng_of_ballast_voyage,
                   :edq,
                   :laden_pa_transit,
                   :ballast_pa_transit,
                   :landen_fuel_consumption_in_pa,
                   :ballast_fuel_consumption_in_pa,
                   :cosuming_lng_of_laden_voyage_leg1,
                   :cosuming_lng_of_laden_voyage_leg2,
                   :cosuming_lng_of_ballast_voyage_leg1,
                   :cosuming_lng_of_ballast_voyage_leg2,
                   :estimated_heel_leg1,
                   :estimated_heel_leg2,
                   :author_id,
                   :updated_by_id,
                   :updated_by_name,
                   :finalized,
                   :created_at,
                   :updated_at

        attribute :ballast_voyage_leg1_port_dept do |object|
          object.ballast_voyage_leg1&.port_dept_name
        end

        attribute :ballast_voyage_leg1_port_arrival do |object|
          object.ballast_voyage_leg1&.port_arrival_name
        end

        attribute :laden_voyage_leg1_port_dept do |object|
          object.laden_voyage_leg1&.port_dept_name
        end

        attribute :laden_voyage_leg1_port_arrival do |object|
          object.laden_voyage_leg1&.port_arrival_name
        end

        attribute :ballast_voyage_leg2_port_dept do |object|
          object.ballast_voyage_leg2&.port_dept_name
        end

        attribute :ballast_voyage_leg2_port_arrival do |object|
          object.ballast_voyage_leg2&.port_arrival_name
        end

        attribute :laden_voyage_leg2_port_dept do |object|
          object.laden_voyage_leg2&.port_dept_name
        end

        attribute :laden_voyage_leg2_port_arrival do |object|
          object.laden_voyage_leg2&.port_arrival_name
        end


        attribute :laden_voyage_leg1 do |object|
          HeelResultSerializer.new(object.laden_voyage_leg1).serializable_hash
        end

        attribute :ballast_voyage_leg1 do |object|
          HeelResultSerializer.new(object.ballast_voyage_leg1).serializable_hash
        end

         attribute :laden_voyage_leg2 do |object|
          HeelResultSerializer.new(object.laden_voyage_leg2).serializable_hash
        end

        attribute :ballast_voyage_leg2 do |object|
          HeelResultSerializer.new(object.ballast_voyage_leg2).serializable_hash
        end

      end
    end
  end
end
