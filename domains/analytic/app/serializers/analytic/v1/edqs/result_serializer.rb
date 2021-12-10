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
                   :heel,
                   :edq,
                   :author_id,
                   :updated_by_id,
                   :updated_by_name,
                   :published,
                   :created_at,
                   :updated_at

        attribute :ballast_voyage_port_dept do |object|
          object.ballast_voyage&.port_dept_name
        end

        attribute :ballast_voyage_port_arrival do |object|
          object.ballast_voyage&.port_arrival_name
        end

        attribute :laden_voyage_port_dept do |object|
          object.laden_voyage&.port_dept_name
        end

        attribute :laden_voyage_port_arrival do |object|
          object.laden_voyage&.port_arrival_name
        end


        attribute :laden_voyage do |object|
          HeelResultSerializer.new(object.laden_voyage).serializable_hash
        end

        attribute :ballast_voyage do |object|
          HeelResultSerializer.new(object.ballast_voyage).serializable_hash
        end

      end
    end
  end
end
